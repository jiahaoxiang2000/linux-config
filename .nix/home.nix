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
    # for live streaming
    inputs.blivedm_rs.packages.${pkgs.system}.default
    inputs.danmu-tts.packages.${pkgs.system}.default

    # neovim 
    neovim
    tree-sitter
    ripgrep
    lazygit

    # IDE
    unityhub
    ((vscode.overrideAttrs (oldAttrs: {
      version = "1.104.2";
      src = pkgs.fetchurl {
        name = "VSCode_1.104.2_linux-x64.tar.gz";
        url = "https://update.code.visualstudio.com/1.104.2/linux-x64/stable";
        sha256 = "0zgsR0nk9zsOeEcKhrmAFbAhvKKFNsC8fXjCnxFcndE=";
      };
    })).override {
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
    jq # json parser
    newsboat # news rss

    # video
    kdePackages.kdenlive
    mpv
    playerctl # for controlling media player

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
    nerd-fonts.zed-mono
    ## typstting
    texliveFull
    typst
    tinymist

  ];
}
