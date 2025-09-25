{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    neovim
    python3
    vscode
    nodejs
    # desktop for hyprland
    foot
    wofi
    xremap
    wl-clipboard
    # fonts
    ## source han is for chinese
    source-han-serif
    source-han-sans
    source-han-mono
  ];
}