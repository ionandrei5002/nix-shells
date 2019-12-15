with import <nixpkgs> {};

let
  	default = pkgs.callPackage ./php-default.nix {};
in
stdenv.mkDerivation rec {	  
	name = "php-env";
	buildInputs = [ default ];
	shellHook = ''
		echo 'Welcome to ${default.name}!';
		echo 'Just look at all of the incredible buildInputs in default.nix we have:';
		echo $buildInputs;
	'';
}