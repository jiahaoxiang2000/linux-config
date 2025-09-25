{ config, pkgs, ... }:

{ 

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

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
    
    # misc
    netease-cloud-music-gtk

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
    font-awesome
    ## typstting
    texliveFull
    typst
    tinymist
  ];
}