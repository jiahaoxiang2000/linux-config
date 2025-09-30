{ config, pkgs, inputs, ... }:

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

  home.stateVersion = "25.05"; 

  home.packages = with pkgs; [
    inputs.blivedm_rs.packages.${pkgs.system}.default

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
    pipx
    nodejs
    rustc
    rustup
    gcc
    uv
    gh
    
    # dependence lib
    gnumake

    # misc
    netease-cloud-music-gtk # netease cloud music
    qqmusic # qq music
    killall
    p7zip # 7z
    kdePackages.okular # pdf reader
    fastfetch # system info
    
    # video
    kdePackages.kdenlive
    mpv

    # desktop for hyprland
    foot # terminal
    wmenu # application launcher
    xremap # keyboard remap
    wl-clipboard # clipboard tool
    pavucontrol # audio setting
    wlr-randr # display setting
    i3bar-river
    i3status-rust # status bar
    hyprshot # screenshot
    hyprlock # lock screen
    dunst # notification

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
