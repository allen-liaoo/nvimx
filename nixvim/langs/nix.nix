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
        inFlake = lib.mkOption {
          type = lib.types.bool;
          default = with config.nvimx.nix.nixd; 
            builtins.any (s: s != "") [
              nixpkgsName nixosConfKey hmConfKey
            ] || flakeInputs != { };
          readOnly = true;
        };
      };
    };
  };

  config = lib.mkIf (config.nvimx.nix.enable) {
    nvimx.lsp.enable = true;

    lsp.servers.nixd = {
      enable = true;
      activate = true;
      config.nixd = {
        diagnostic.suppress = [ "sema-extra-with" ];
      };
    };

    # tell nixd of flake inputs to enable lsp features
    # Can't get it to work with config in native nixvim
    lsp.luaConfig.post = with config.nvimx.nix.nixd; let
      wrapInQuotes = s: s |> lib.splitString "." |> map (s': ''\"${s'}\"'') |> builtins.concatStringsSep ".";
    in lib.optionalString inFlake ''
      local lsp = vim.lsp

      -- search up the path for flake directory
      local function find_flake_dir()
        local dir = vim.fn.getcwd()
        while dir ~= "/" do
          if vim.fn.filereadable(dir .. "/flake.nix") == 1 then
            return dir
          end
          dir = vim.fn.fnamemodify(dir, ":h")
        end
    
        return nil
      end

      local flake_dir = find_flake_dir()
      if not flake_dir then
        flake_dir = vim.fn.getcwd()
      end
      local flakeExpr = '(builtins.getFlake "' .. flake_dir .. '")'

      lsp.config("nixd", {
        settings = {
          nixd = {
            ${lib.optionalString (nixpkgsName != "") ''
            nixpkgs = {
              expr = flakeExpr .. ".inputs.\"${nixpkgsName}\".legacyPackages.\"${system}\"",
            },'' }
            options = {
              ${
              # would like to disable nixos options when using home manager but that is not possible; nixd will fallback to <nixpkgs>
              # See: https://github.com/nix-community/nixd/issues/807
              lib.optionalString (nixosConfKey != "") ''
              nixos = {
                expr = flakeExpr .. ".nixosConfigurations.\"${nixosConfKey}\".options",
              },'' }
              ${lib.optionalString (hmConfKey != "") ''
              ["home-manager"] = {
                expr = flakeExpr .. ".homeConfigurations.\"${hmConfKey}\".options",
              },'' }
              ${(lib.mapAttrsToList (input: modulePath: ''
              ["${input}"] = {
                expr = flakeExpr .. ".inputs.\"${input}\".${wrapInQuotes modulePath}.options",
              },'') flakeInputs)
                |> lib.concatStringsSep "\n" }
            },
          },
        },
      })
      lsp.enable("nixd")
    '';

    nvimx.treesitter.enable = true;

    plugins.treesitter.grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
      nix
    ];
  };
}

# debug:
# :lua print(vim.inspect(vim.lsp.get_clients()))
