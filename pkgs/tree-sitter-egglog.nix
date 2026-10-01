{
  pkgs,
  fetchFromGitHub,
  ...
}:

pkgs.tree-sitter.buildGrammar {
  language = "egglog";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog-language-server";
    rev = "c6fd9fca1b2f1a42c9d38869eb56d89333301033";
    hash = "sha256-IX/KWa7ICpzQ9oztCJ5Gt+RC/xSvYt5UqxtDTf5uSRI=";
  };
  location = "tree-sitter-egglog";
  meta = {
    description = "Tree-sitter grammar for egglog";
    homepage = "https://github.com/egraphs-good/egglog-language-server";
  };
}
