{ pkgs ? import <nixpkgs> {} }:
with pkgs;

let
  inherit stdenv fetchFromGitHub;
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
in pkgs.stdenv.mkDerivation rec {
  version = "1.34.1-1";
  name = "luv-${version}";

  src = fetchFromGitHub {
    owner = "luvit";
    repo = "luv";
    rev = "${version}";
    sha256 = "0lg3kncaka1mx18k0w4wsylsa6xnp7m11n68wgn38sph7f2nn1x9";
  };
  
  configurePhase = ''
    echo "test"
    substituteInPlace Makefile --replace "git submodule update --init deps/libuv" ""
    substituteInPlace Makefile --replace "git submodule update --init deps/luajit" ""
    substituteInPlace Makefile --replace "git submodule update --init deps/lua-compat-5.3" ""
    cat $PWD/Makefile
    BUILD_MODULE=OFF BUILD_SHARED_LIBS=ON WITH_SHARED_LIBUV=ON LUA_BUILD_TYPE=System WITH_LUA_ENGINE=Lua make
  '';
  #configureFlags = [
  #  "BUILD_MODULE=OFF"
  #  "BUILD_SHARED_LIBS=ON"
  #  "WITH_SHARED_LIBUV=ON"
   #  "LUA_BUILD_TYPE=System"
   #  "WITH_LUA_ENGINE=Lua"
   #];
    
  buildInputs = [
    git
    cmake
    gnumake
    autoconf
    pkgconfig
    libuv
    lua
    lua53Packages.compat53
    msgpack
  ];

  cmakeFlags = [
    "-DBUILD_MODULE=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DWITH_SHARED_LIBUV=ON"
    "-DWITH_LUA_ENGINE=Lua"
    "-DLUA_BUILD_TYPE=System"
    "-DLUA_COMPAT53_DIR=OFF"
  ];
  
  preConfigure = ''
    substituteInPlace Makefile --replace "git submodule update --init deps/libuv" ""
    substituteInPlace Makefile --replace "git submodule update --init deps/luajit" ""
    substituteInPlace Makefile --replace "git submodule update --init deps/lua-compat-5.3" ""
    cat $PWD/Makefile
  '';

}
