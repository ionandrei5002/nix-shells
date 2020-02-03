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
    sha256 = "07970qiqfzfgqilk3wmxi96vc4mvjykjkdwdjwjzn82n6vgqq34q";
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
