{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  inherit stdenv glibc gcc-unwrapped dpkg autoPatchelfHook;
in
pkgs.stdenv.mkDerivation {
  name = "neovim-latest";
  src = pkgs.fetchurl {
    url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz";
    sha256 = "12w6gsmhzsy787rh9xvf5a54l5bp6572a2azx93dm46bn45yr0qk";
  };

  nativeBuildInputs = [ 
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glibc
    gcc-unwrapped
  ];

  installPhase = ''
    mkdir $out
    ${pkgs.gnutar}/bin/tar xf $src --strip 1 -C $out
  '';
}
