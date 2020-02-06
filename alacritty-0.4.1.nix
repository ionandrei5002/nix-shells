{ pkgs ? import <nixpkgs> {} }:
with pkgs;

pkgs.stdenv.mkDerivation {
  name = "alacritty-0.4.1";
  src = pkgs.fetchurl {
    url = "https://github.com/alacritty/alacritty/releases/download/v0.4.1/Alacritty-v0.4.1-ubuntu_18_04_amd64.tar.gz";
    sha256 = "1x2cnzb34gm91vw59cw5cmyxdqms2i0j7bycjfyq37ksi25nil3v";
  };

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out/bin
    ${pkgs.gnutar}/bin/tar xf $src -C $out/bin
  '';
}
