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
  ];
}