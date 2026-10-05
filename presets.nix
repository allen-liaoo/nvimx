let
  base = {
    imports = [ ./nvimx ];
  };
in
{
  default = base;
  base = base;
  c = base // { nvimx.preset.c.enable = true; };
  configs = base // { nvimx.preset.configs.enable = true; };
  egglog = base // { nvimx.preset.egglog.enable = true; };
  java = base // { nvimx.preset.java.enable = true; };
  latex = base // { nvimx.preset.latex.enable = true; };
  llvm-ir = base // { nvimx.preset.llvm-ir.enable = true; };
  markdown = base // { nvimx.preset.markdown.enable = true; };
  nix = base // { nvimx.preset.nix.enable = true; };
  rust = base // { nvimx.preset.rust.enable = true; };
  shells = base // { nvimx.preset.shells.enable = true; };
  typst = base // { nvimx.preset.typst.enable = true; };
}
