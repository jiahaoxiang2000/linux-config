{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    tree
    neovim
    python3
    vscode
    nodejs
  ];
}