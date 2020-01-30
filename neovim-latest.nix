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
    sha256 = "1l2zaxags07xppm0fxq846zha580091ncmszc09ykka0cxb4pvnw";
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
