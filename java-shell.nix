with import <nixpkgs-unstable> {};

stdenv.mkDerivation {
	name = "java-env";
	nativeBuildInputs = [
		openjdk
		maven
	];
}