{ pkgs ? import <nixpkgs> {} }:
with pkgs;

stdenv.mkDerivation rec {
	name = "python-env";
	buildInputs = [
        (
            pkgs.python3.buildEnv.override rec {
                extraLibs = with python3Packages; [
                    pandas
                    matplotlib
                    tkinter
                    requests
                    dask
                ];
            }
        )
    ];
}