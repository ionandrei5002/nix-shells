{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  	inherit stdenv fetchurl;
	version = "7.4.0";
in
pkgs.stdenv.mkDerivation rec {
	name = "php-${version}";
	enableParallelBuilding = true;
	configureFlags = [ 
		"--with-config-file-scan-dir=/etc/php.d"
		"--disable-all"
	];
	buildInputs = [
		pkgconfig
	];
	src = fetchurl {
		url = "https://www.php.net/distributions/php-${version}.tar.bz2";
		sha256 = "bf206be96a39e643180013df39ddcd0493966692a2422c4b7d3355b6a15a01c0";
	};
}