with import <nixpkgs-unstable> {};

stdenv.mkDerivation {
	name = "java-env";
	buildInputs = [
		openjdk
		maven
	];
}