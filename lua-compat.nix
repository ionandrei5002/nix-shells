{pkgs ? import <nixpkgs> {}}:
with pkgs;

stdenv.mkDerivation rec {
  name = "lua-compat";
  version = "5.3";

  src = fetchurl {
    url = "https://github.com/keplerproject/${name}-${version}/archive/v0.7.tar.gz";
    sha256 = "18m0vgzyb9qxx5abn0xwvw8as1pmy1brcc1qh0hv7nd32hqs5hxy";
  };
}
