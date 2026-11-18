{
  pkgs,
  ...
}:

{
  # image.nvim, for coil's previews 
  # patched to fix kitty_method="unicode-placeholders" images 
  # 1. drawn one column left,
  # 2. drawn with Neovim's leftover attributes, e.g. an underline across every row)
  plugins.image.package = pkgs.vimPlugins.image-nvim.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./patches/image/0001-fix-kitty-place-unicode-placeholders-in-the-right-co.patch
      ./patches/image/0002-fix-kitty-draw-unicode-placeholders-without-Neovim-s.patch
    ];
  });

}
