{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let 
  inherit stdenv fetchurl;
  version = "0.4.3";
  neovimLuaEnv = lua.withPackages(ps:
  (with ps; 
    [
      lpeg
      luabitop
      mpack
      nvim-client
      luv
      coxpcall
      busted
      luafilesystem
      penlight
      inspect
      luaffi
    ]
  ));
in
pkgs.stdenv.mkDerivation rec {
  name = "neovim-${version}";

  src = fetchFromGitHub {
    owner = "neovim";
    repo = "neovim";
    rev = "v${version}";
    sha256 = "03p7pic7hw9yxxv7fbgls1f42apx3lik2k6mpaz1a109ngyc5kaj";
  };
  
  enableParallelBuilding = true;

  #nativeBuildInputs = [
  #  gettext
  #  cmake
  #  pkgconfig
  #];
  
  buildInputs = [
    gettext
    gperf
    libtermkey
    libuv
    libvterm
    luaPackages.luv
    msgpack
    ncurses
    neovimLuaEnv
    unibilium
    jemalloc
    libiconv
    procps
    glibcLocales
    cmake
    pkgconfig
  ];

  postPatch = ''
    substituteInPlace src/nvim/version.c --replace NVIM_VERSION_CFLAGS "";
  '';
  # check that the above patching actually works
  disallowedReferences = [ 
    stdenv.cc 
  ];

  cmakeFlags = [
    "-DGPERF_PRG=${gperf}/bin/gperf"
    "-DLUA_PRG=${neovimLuaEnv.interpreter}"
    "-DPREFER_LUA=ON"
    "-DBUSTED_PRG=${neovimLuaEnv}/bin/busted"
    
    "-DLIBLUV_LIBRARY=${lua.pkgs.luv}/lib/lua/${lua.luaversion}/luv.so"

    # This isn't part of neovim-unwrapped's default.nix but it's my attempt to
    # fix the missing header file as that's where I've found that luv.h
    "-DLIBLUV_INCLUDE_DIR=${neovimLuaEnv}/include"
  ];

  # triggers on buffer overflow bug while running tests
  hardeningDisable = [ "fortify" ];

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/nvim/CMakeLists.txt --replace "    util" ""
  '';

  postInstall = stdenv.lib.optionalString stdenv.isLinux ''
    sed -i -e "s|'xsel|'${xsel}/bin/xsel|g" $out/share/nvim/runtime/autoload/provider/clipboard.vim
  '';

  # export PATH=$PWD/build/bin:${PATH}
  shellHook=''
    export VIMRUNTIME=$PWD/runtime
  '';
}
