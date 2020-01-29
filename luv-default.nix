{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
  name = "luv";
  version = "1.34.1-1";

  src = fetchurl {
    url = "https://github.com/luvit/luv/archive/${version}.tar.gz";
    sha256 = "1w2z35ri4mp55rfsx9r5axiawrn1y14c4a93d2apr9izw1c8crmw";
  };
}
