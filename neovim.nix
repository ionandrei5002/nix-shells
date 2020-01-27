{ pkgs ? import <nixos> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "neovim-with-plugs";
  buildInputs = [
    neovim
    php
    php73Packages.composer
    rls
    rustPlatform.rustcSrc
    nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    (
      pkgs.python3.buildEnv.override rec {
        extraLibs = with python3Packages; [
          python-language-server
        ];
      }
    )    
  ];
  RUST_SRC_PATH   = "${rustPlatform.rustcSrc}";
}
