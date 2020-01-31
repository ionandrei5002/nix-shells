{pkgs ? import <nixpkgs> {}}:

{
  neovim  = import ./neovim-latest.nix { pkgs = import <nixpkgs-unstable> {}; };
  nodejs  = pkgs.nodejs-12_x;
  yarn    = pkgs.yarn;
  vifm    = pkgs.vifm;
  #clion   = (import <nixpkgs-unstable> {}).jetbrains.clion;
}
