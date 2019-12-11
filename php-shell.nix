with import <nixos> {};

stdenv.mkDerivation {
	name = "php-env";
	nativeBuildInputs = [
		php
	];
}
