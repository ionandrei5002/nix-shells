{pkgs ? import <nixpkgs> {}}:

{
  hello   = import ./hello.nix { pkgs = import <nixpkgs> {}; };
  neovim  = import ./neovim.nix { pkgs = import <nixpkgs> {}; };
  nodejs  = pkgs.nodejs-12_x;
  yarn    = pkgs.yarn;
}
