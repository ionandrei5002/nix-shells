{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  rpath = stdenv.lib.makeLibraryPath [
    gcc-unwrapped
    glibc
  ];
in
pkgs.stdenv.mkDerivation {
  name = "neovim-latest";
  src = pkgs.fetchurl {
    url = "https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz";
    sha256 = "1ix2wh4f2b78wbryyq4y4za7vvbnw557zxhgwq23i64d37xsa6wg";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir $out
    ${pkgs.gnutar}/bin/tar xf $src --strip 1 -C $out
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" \
      $out/bin/nvim
  '';
}
