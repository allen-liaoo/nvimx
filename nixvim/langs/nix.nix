{
  lib,
  system,
  config,
  ...
}:

{
  options = {
    nvimx.nixd = {
      inFlake = lib.mkOption {
        type = lib.types.bool;
        default = with config.nvimx.nixd; 
          [ nixpkgsName nixosConfKey hmConfKey ]
          |> builtins.filter (s: s != "") 
          |> (l: builtins.length l != 0);
      };
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
      hmConfKey  = lib.mkOption {
        type = lib.types.str;
        description = "Name of homeConfigurations key in the flake, used for looking up Home Manager options. Only set this if using HM standalone.";
        default = "";
      };
    };
  };

  imports = [ ./lsp.nix ];

  config = {
    lsp.servers.nixd = {
      enable = true;
      activate = true;
      config.nixd = {
        diagnostic.suppress = [ "sema-extra-with" ];
      };
    };

    # Per-host/user nixd configuration
    # Can't get it to work with config in native nixvim
    lsp.luaConfig.post = let
      flakeExpr = ''(builtins.getFlake (builtins.toString ./.))''; # should be the flake one runs nixvim in
    in lib.optionalString (config.nvimx.nixd.inFlake) ''
      local lsp = vim.lsp
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
            ${lib.optionalString (config.nvimx.nixd.nixpkgsName != "") ''
            nixpkgs = {
              expr = flakeExpr .. ".inputs.${config.nvimx.nixd.nixpkgsName}.legacyPackages.\"${system}\"",
            },'' }
            options = {
              ${lib.optionalString (config.nvimx.nixd.nixosConfKey != "") ''
              nixos = {
                expr = flakeExpr .. ".nixosConfigurations.${config.nvimx.nixd.nixosConfKey}.options",
              },'' }
              ${lib.optionalString (config.nvimx.nixd.hmConfKey != "") ''
              ["home-manager"] = {
                expr = flakeExpr .. ".homeConfigurations.\"${config.nvimx.nixd.hmConfKey}\".options",
              },'' }
            },
          },
        },
      })
      lsp.enable("nixd")
    '';
  };
}
