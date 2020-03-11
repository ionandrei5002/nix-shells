{ pkgs ? import <nixpkgs> {} }:
with pkgs;

pkgs.stdenv.mkDerivation {
  name = "phar-composer";
  src = pkgs.fetchurl {
    url = "https://github.com/clue/phar-composer/releases/download/v1.1.0/phar-composer-1.1.0.phar";
    sha256 = "0zri57hcpjjpbcla883r73sdij0nqzk5ifyqp6psfn8xbxwicqnx";
  };
  dontUnpack = true;

  nativeBuildInputs = [ pkgs.makeWrapper pkgs.unzip ];
  buildInputs = [ php ];

  installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/libexec
      cp $src $out/libexec/phar-composer-1.1.0.phar
      makeWrapper ${php}/bin/php $out/bin/phar-composer \
        --add-flags "$out/libexec/phar-composer-1.1.0.phar" \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.unzip ]}
  '';
}
