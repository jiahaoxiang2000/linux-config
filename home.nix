{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    # IDE
    neovim
    vscode

    # dev environment
    python3
    nodejs
    rustc
    rustup
    gcc
    
    # dependence lib

    # desktop for hyprland
    foot
    wofi
    xremap
    wl-clipboard
    waybar

    # writing 
    ## source han is for chinese
    source-han-serif
    source-han-sans
    source-han-mono
    ## typstting
    texliveFull
    typst
    tinymist
  ];
}