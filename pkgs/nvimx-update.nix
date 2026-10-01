{
  writeShellApplication,
  git,
  nix,
  coreutils,
}:

writeShellApplication {
  name = "nvimx-update";
  runtimeInputs = [
    git
    nix
    coreutils
  ];
  text = ''
    shopt -s nullglob
    cd "$(git rev-parse --show-toplevel)"

    for f in projs/*/flake.nix; do
      dir=$(dirname "$f")
      echo "re-locking $dir"
      nix flake update nvimx --flake "./$dir"  # re-sync nvimx + its transitive pins
    done
  '';
}
