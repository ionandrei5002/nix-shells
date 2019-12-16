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
		"--with-curl=${curl.dev}"
		"--with-openssl"
	];
	nativeBuildInputs = [
		autoconf 
		pkgconfig 
	];
	buildInputs = [
		libxml2
		sqlite
		curl
		openssl
	];
	src = fetchurl {
		url = "https://www.php.net/distributions/php-${version}.tar.bz2";
		sha256 = "bf206be96a39e643180013df39ddcd0493966692a2422c4b7d3355b6a15a01c0";
	};

	hardeningDisable = [ "bindnow" ];

	preConfigure = ''
		# Don't record the configure flags since this causes unnecessary
		# runtime dependencies
		for i in main/build-defs.h.in scripts/php-config.in; do
			substituteInPlace $i \
			--replace '@CONFIGURE_COMMAND@' '(omitted)' \
			--replace '@CONFIGURE_OPTIONS@' "" \
			--replace '@PHP_LDFLAGS@' ""
		done
		#[[ -z "$libxml2" ]] || addToSearchPath PATH $libxml2/bin
		export EXTENSION_DIR=$out/lib/php/extensions
		configureFlags+=(--with-config-file-path=$out/etc \
			--includedir=$dev/include)
		./buildconf --force
	'';

	postInstall = ''
		test -d $out/etc || mkdir $out/etc
		cp php.ini-production $out/etc/php.ini
	'';

	postFixup = ''
		mkdir -p $dev/bin $dev/share/man/man1
		mv $out/bin/phpize $out/bin/php-config $dev/bin/
		mv $out/share/man/man1/phpize.1.gz \
			$out/share/man/man1/php-config.1.gz \
			$dev/share/man/man1/
	'';

	stripDebugList = "bin sbin lib modules";

	outputs = [ "out" "dev" ];
}