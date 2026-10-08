# Cursorline of current word
# https://github.com/RRethy/vim-illuminate
{ ... }:
{
  plugins.illuminate = {
    enable = true;
  };

  highlightOverride = {
    IlluminatedWordText = {
      underline = true;
      bold = false;
    };
    IlluminatedWordRead = {
      underline = true;
      bold = false;
    };
    IlluminatedWordWrite = {
      underline = true;
      bold = false;
    };
  };
}
