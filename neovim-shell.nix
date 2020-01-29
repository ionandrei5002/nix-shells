let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
in
  with nixpkgs;

stdenv.mkDerivation rec {
  name = "neovim-shell";
  buildInputs = [
    git
    neovim
    nodejs-12_x
    yarn
    nixpkgs.latest.rustChannels.stable.rust
    rustracer
    rustfmt
    rustPlatform.rustcSrc
    rls
    cargo
    openjdk
    maven
    pkgconfig
    (
      nixpkgs.python3.buildEnv.override rec {
        extraLibs = with python3Packages; [
          python3Packages.python-language-server
        ];
      }
    )
  ];

  buildCommand = ''
    which java
    echo "JAVA_HOME=$JAVA_HOME"
    exit 1
  '';

  RUST_BACKTRACE  = 1;
  RUST_SRC_PATH   = "${latest.rustChannels.stable.rust-src}/lib/rustlib/src/rust/src";
}
