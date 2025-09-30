# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  # use the china mirrors
  nix.settings.substituters = lib.mkForce [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use Zen kernel
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Hong_Kong";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://192.168.71.202:7890/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
    inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true; 
        # plasma6Support = true; 
        addons = with pkgs; [
          fcitx5-chinese-addons
          fcitx5-mozc
          fcitx5-gtk #  Fcitx5 gtk im module and glib based dbus client library
          fcitx5-material-color
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
        ];
        settings = {
          addons = {
            classicui.globalSection.Theme = "Material-Color-deepPurple";
            classicui.globalSection.DarkTheme = "Material-Color-deepPurple";
            pinyin.globalSection = {
              PageSize = 9;
              CloudPinyinEnabled = "True";
              CloudPinyinIndex = 2;
            };
            cloudpinyin.globalSection = {
              Backend = "Baidu";
            };
          };
          globalOptions = { "Hotkey/TriggerKeys" = { "0" = "Control+Shift_L"; }; };
          inputMethod = {
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "pinyin";
            GroupOrder."0" = "Default";
          };
        };
      };
    };
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # X11 not needed with Hyprland (Wayland)
  # services.xserver.enable = true;

  # Enable SDDM display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.river = {
    enable = true;
    # xwayland.enable = true;
  };

  # Ensure DISPLAY and WAYLAND_DISPLAY are available to user services
  environment.sessionVariables = {
    # Make sure River session exports these properly
    NIXOS_OZONE_WL = "1";
  };

  services.dbus.enable = true;
  programs.dconf.enable = true;

  # Enable NVIDIA support 
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    # Use the open source version of the kernel module (for driver 515.43.04+)
    # Only available on driver 515.43.04+
    open = false;  # Set to true if you want open-source drivers
    
    # Enable NVIDIA settings menu
    nvidiaSettings = true;
    
    # Select the appropriate driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    # Or use: config.boot.kernelPackages.nvidiaPackages.beta
    # Or use: config.boot.kernelPackages.nvidiaPackages.latest
    
  };

  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Automatic garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Optimize store automatically
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  # Limit number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;

  # Enable bluetooth support.
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        ControllerMode = "dual";
      };
    };
  };
  services.blueman.enable = true;

  # Disable specific Bluetooth controller via udev
  services.udev.extraRules = ''
    # Disable USB Bluetooth controller with 60:FF:9E:DB:C8:C2 (Vendor: 13d3, Product: 3558)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="13d3", ATTRS{idProduct}=="3558", RUN+="/bin/sh -c 'echo 1 > /sys$devpath/remove'"
    KERNEL=="uinput", GROUP="input", TAG+="uaccess"
  '';
  
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
     enable = true;
     pulse.enable = true;
  };
  
  # xdg
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [ pkgs.xdg-desktop-portal-wlr];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  hardware.uinput.enable = true;
  boot.kernelModules = [ "uinput" ];

  # Define a user account. Don't forget to set a password with 'passwd'.
   users.users.isomo = {
     isNormalUser = true;
     extraGroups = [ "wheel" "input" ]; # Enable 'sudo' for the user.
     shell = pkgs.zsh;
   };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "kubectl" "history" "colored-man-pages" "fzf" ];
      theme = "robbyrussell";
    };

  };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     git
     fzf # Fuzzy finder for enhanced shell search
     bat # Better cat with syntax highlighting for fzf preview
     tree # Directory tree view for fzf
     # Audio and development libraries
     alsa-lib
     openssl
   ];

  nixpkgs.config.allowUnfree = true;

  # System-wide environment variables
  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.alsa-lib.dev}/lib/pkgconfig:${pkgs.openssl.dev}/lib/pkgconfig:${pkgs.pkg-config}/lib/pkgconfig";
    ALSA_PCM_CARD = "default";
    ALSA_PCM_DEVICE = "0";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  # system.stateVersion = "25.05"; # Did you read the comment?
  system.stateVersion = "25.05"; # Did you read the comment?

}

