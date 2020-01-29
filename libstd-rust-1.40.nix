# CREATE DERIVATION FROM DEB FILE
{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  rpath = stdenv.lib.makeLibraryPath [
    gcc-unwrapped
    glibc
  ];
  version = "1.40.0";
in
pkgs.stdenv.mkDerivation {
  name = "libstd-rust-${version}";
  src = pkgs.fetchurl {
    url = "http://ftp.br.debian.org/debian/pool/main/r/rustc/libstd-rust-1.40_1.40.0+dfsg1-5_amd64.deb";
    sha256 =  "154x8lclfivxnjkm6rrnnjp3c1amlgmbhsil66kapavhh6qvc2w0";
  };

  nativeBuildInputs = [
    dpkg
  ];

  buildInputs = [
    which
    zlib
    glibc
    gcc-unwrapped
  ];

  unpackPhase = "true";

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
    chmod -R +x $out/usr/lib/x86_64-linux-gnu/*
  '';

  postFixup = ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath = "${rpath}" \
      $out/usr/lib/x86_64-linux-gnu/librustc_driver-63c24450e7490092.so
  '';
}
