{
  lib,
  system,
  config,
  ...
}:

{
  options = {
    nvimx.nix = {
      enable = lib.mkEnableOption "nix";

      nixd = {
        # Info needed for Nixd lookup of nixpkgs/nixos options/hm options/custom flake input options
        nixpkgsName = lib.mkOption {
          type = lib.types.str;
          description = "Name of nixpkgs input in the flake, used for looking up packages.";
          default = "";
        };
        nixosConfKey = lib.mkOption {
          type = lib.types.str;
          description = "Name of nixosConfigurations key in the flake, used for looking up NixOS options.";
          default = "";
        };
        hmConfKey = lib.mkOption {
          type = lib.types.str;
          description = "Name of homeConfigurations key in the flake, used for looking up Home Manager options. Only set this if using HM standalone.";
          default = "";
        };
        flakeInputs = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          description = ''Mapping of input name in flake to path to lookup its options.
            If the module is at \"inputs.stylix.homeModules.stylix\", then write \"stylix\" = \"homeModules.stylix\";
          '';
          default = { };
        };
      };
    };
  };

config = let
  q = "\\\""; # nix's quote ("), escaped in lua (\"), escaped in nix
  flakeExpr = "(builtins.getFlake ${q}\' .. find_flake_dir() .. \'${q})"; # see lsp.luaConfig below
  # exprOfInput produces a nix expr in lua that gets the necessary path of an input
  # for nixpkgs, this is the pkgs path
  # for flake inputs (not including nixos or home-manager), this is the path to module options
    # https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
  exprOfInput = (input: path: "\'${flakeExpr}.inputs.${path}\'");
in lib.mkIf (config.nvimx.nix.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.nixd = {
      enable = true;
      activate = true;
      config = {
        cmd = [ "nixd" ]; # necessary
        settings.nixd = with config.nvimx.nix.nixd; {
          diagnostic.suppress = [ "sema-extra-with" ];

          nixpkgs.expr = if nixpkgsName != "" 
            then {
              # need to use __raw because we want flake_dir in flakeExpr to be interpolated 
              __raw =  "\'${flakeExpr}.inputs.${nixpkgsName}.legacyPackages.${system}\'";
            }
            else "import <nixpkgs> { }";

          # flake inputs and default values
          options = lib.mapAttrs
            (_: path: {
              expr.__raw = "\'${path}\'";
            })
            ( # input = full path (flake.full_path) to module options
              lib.optionalAttrs (nixosConfKey != "") {
                "nixos" = "${flakeExpr}.nixosConfigurations.${nixosConfKey}.options";
              } // lib.optionalAttrs (hmConfKey != "") {
                "[\"home-manager\"]" = "${flakeExpr}.homeConfigurations.${hmConfKey}.options";
              } // lib.mapAttrs' (input: path: {
                name = "[\"${input}\"]";
                value = "${flakeExpr}.inputs.${input}.${path}.options";
              }) flakeInputs
            );
        };
      };
    };

    lsp.luaConfig.pre = ''
      -- search up the path for flake directory, falllback to cwd
      function find_flake_dir()
        local dir = vim.fn.getcwd()
        while dir ~= "/" do
          if vim.fn.filereadable(dir .. "/flake.nix") == 1 then
            return dir
          end
          dir = vim.fn.fnamemodify(dir, ":h")
        end
        return vim.fn.getcwd()
      end
    '';

    nvimx.treesitter.enable = true;
    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      nix
    ];
  };
}

# debug:
# :lua print(vim.inspect(vim.lsp.get_clients()))
