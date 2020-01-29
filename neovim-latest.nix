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
    sha256 = "12w6gsmhzsy787rh9xvf5a54l5bp6572a2azx93dm46bn45yr0qk";
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
