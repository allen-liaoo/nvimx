{
  lib,
  pkgs,
  fetchFromGitHub,
  jdk21,
  git,
  which,
  llvmPackages,
  ...
}:

let
  version = "0.1.0";

  # https://github.com/zaninime/sbt-derivation, vendored here (rather than
  # as a flake input) so this package stays plain callPackage/nixpkgs
  # compatible.
  sbt-derivation-src = fetchFromGitHub {
    owner = "zaninime";
    repo = "sbt-derivation";
    rev = "6762cf2c31de50efd9ff905cbcc87239995a4ef9";
    hash = "sha256-Pnej7WZIPomYWg8f/CZ65sfW85IfIUjYhphMMg7/LT0=";
  };
  mkSbtDerivation = import sbt-derivation-src;
in
mkSbtDerivation {
  inherit pkgs;
  pname = "llvm-ir-lsp";
  inherit version;

  src = fetchFromGitHub {
    owner = "indoorvivants";
    repo = "llvm-ir-lsp";
    rev = "v${version}";
    hash = "sha256-7EKp2hQzgDAgVU4z2rOhQ5Wm/JkBhNJ5JZWhZAh/wkg=";
  };

  # Trust on first use: this hash pins sbt's resolved Maven/Ivy dependency
  # set (via the dependencies FOD below). Bump it by setting lib.fakeHash,
  # rebuilding, and copying the hash Nix reports back in.
  depsSha256 = "sha256-jB78dfZs8HABloReuL191At8KaJMW1eDkPtmkmJb/9A=";

  # The deps archive picks up absolute /nix/store paths (e.g. baked into
  # sbt's .boot/coursier caches referencing the JDK/clang used to warm them
  # up); fixed-output derivations may not reference other store paths.
  overrideDepsAttrs = _final: _prev: {
    __structuredAttrs = true;
    unsafeDiscardReferences.out = true;
  };

  nativeBuildInputs = [
    jdk21
    git
    which
    llvmPackages.clang
    llvmPackages.lld
  ];

  depsWarmupCommand = "sbt buildBinaryPlatformRelease";

  buildPhase = ''
    runHook preBuild
    sbt buildBinaryPlatformRelease
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 out/release/llvm-ir-lsp* $out/bin/llvm-ir-lsp
    runHook postInstall
  '';

  meta = {
    description = "Language server for navigating LLVM IR (.ll) files";
    homepage = "https://github.com/indoorvivants/llvm-ir-lsp";
    mainProgram = "llvm-ir-lsp";
  };
}
