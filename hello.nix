{pkgs ? import <nixpkgs> {}}:
with pkgs;

stdenv.mkDerivation rec {
  name = "hello";
  version = "2.10";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/hello/hello-${version}.tar.gz";
    sha256 = "0ssi1wpaf7plaswqqjwigppsg5fyh99vdlb9kzl7c9lng89ndq1i";
  };
}
