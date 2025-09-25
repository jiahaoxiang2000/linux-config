# NixOS Configuration

This repository contains my personal NixOS system configuration, managing both system-level and user-level settings through a declarative approach using Nix flakes and Home Manager.

## Overview

This configuration provides a complete desktop environment setup with:

- **Hyprland** (Wayland compositor)
- **NVIDIA** driver support with Wayland compatibility
- **Chinese input method** (Fcitx5 with Pinyin)
- **Development environment** (Python, Node.js, Rust, C++)
- **Modern desktop applications** and tools

## File Structure

### Core Configuration Files

| File                              | Purpose              | Description                                                                                                                             |
| --------------------------------- | -------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `flake.nix`                       | Main Input File      | Defines flake inputs (nixpkgs, home-manager, Hyprland) and system configuration structure                                               |
| `.nix/hardware-configuration.nix` | Hardware Settings    | Auto-generated hardware-specific configuration including disk UUIDs, kernel modules, and filesystem mounts. **Do not modify manually.** |
| `.nix/configuration.nix`          | System Configuration | System-level settings including GPU drivers, input methods, desktop environment, and system services                                    |
| `.nix/home.nix`                   | User Configuration   | User-level packages, themes, and applications managed by Home Manager                                                                   |

### Additional Configuration

- **`.nix/`** - Directory containing all NixOS configuration files for better organization
- **`.config/`** - Traditional application configuration files for software that doesn't use Nix for configuration

## Key Features

### Desktop Environment

- **Hyprland** - Modern Wayland compositor
- **SDDM** - Display manager with Wayland support
- **Waybar** - Status bar for Wayland
- **Wofi** - Application launcher
- **GTK theming** - Adwaita dark theme with Papirus icons

### Input & Internationalization

- **Fcitx5** - Input method framework with Chinese support
- **Multiple locales** - English (US) and Chinese (Simplified) support
- **Custom hotkeys** - Alt+Space for input method switching

### Development Tools

- **Editors**: Neovim, VS Code
- **Languages**: Python 3, Node.js, Rust, C/C++
- **Writing**: LaTeX (TeXLive), Typst with Tinymist LSP
- **Fonts**: Source Han family for Chinese text support

### Hardware Support

- **NVIDIA drivers** - Stable drivers with Wayland modesetting
- **Bluetooth** - Full Bluetooth support with device management
- **Audio** - Ready for PipeWire/PulseAudio setup

## Usage

### Rebuilding the System

```bash
# Rebuild and switch to new configuration
sudo nixos-rebuild switch --flake .#desktop

# Test configuration without switching
sudo nixos-rebuild test --flake .#desktop

# Build configuration without activating
sudo nixos-rebuild build --flake .#desktop
```

## System Information

- **NixOS Version**: 25.05
- **Architecture**: x86_64-linux
- **Boot Loader**: systemd-boot (UEFI)
- **Display Protocol**: Wayland
- **Time Zone**: Asia/Hong_Kong
