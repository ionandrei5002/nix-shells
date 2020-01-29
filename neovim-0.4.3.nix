{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  rpath = stdenv.lib.makeLibraryPath [
    gcc-unwrapped
    glibc
  ];
  version = "v0.4.3";
in
pkgs.stdenv.mkDerivation {
  name = "neovim-0.4.3";
  src = pkgs.fetchurl {
    url = "https://github.com/neovim/neovim/releases/download/${version}/nvim-linux64.tar.gz";
    sha256 = "0swcsgp8sywqc6i3664cq9np2yfqjdsmmdmy6x384d24w33117kv";
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
