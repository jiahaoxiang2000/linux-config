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
  
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
    ];
  };
  
  home.stateVersion = "25.11"; 

  home.packages = with pkgs; [
    # IDE
    neovim
    (vscode.override {
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--wayland-text-input-version=3"
        "--disable-gpu-sandbox"
        "--disable-gpu-compositing"
      ];
    })

    # dev environment
    python3
    nodejs
    rustc
    rustup
    gcc
    uv
    
    # dependence lib
    gnumake

    # misc
    netease-cloud-music-gtk
    killall
    
    # video
    kdePackages.kdenlive

    # desktop for hyprland
    foot
    wmenu
    xremap
    wl-clipboard
    waybar
    pavucontrol
    wlr-randr
    i3bar-river
    i3status-rust

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
