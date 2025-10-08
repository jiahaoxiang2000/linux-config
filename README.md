# Linux Configuration

This repository contains my personal Linux system configuration files (dotfiles) for a customized development and desktop environment.

## Overview

This configuration provides a complete setup with:

- **Wayland desktop environment** with River compositor
- **Development tools** for Python, Node.js, Rust, and C++
- **Chinese input method** support
- **Terminal environment** with Zsh, Oh My Zsh, and custom functions
- **Mirror configurations** for faster package downloads in China

## File Structure

### Configuration Directories

| Directory/File | Purpose             | Description                                                                |
| -------------- | ------------------- | -------------------------------------------------------------------------- |
| `.config/`     | Application Configs | Traditional application configuration files for desktop apps and tools     |
| `.nix/`        | NixOS Configuration | NixOS-specific system configuration (see [.nix/README.md](.nix/README.md)) |
| `.zshrc`       | Shell Configuration | Zsh shell configuration with Oh My Zsh, custom functions, and aliases      |
| `.gitconfig`   | Git Configuration   | Git user settings and aliases                                              |

### Key Configuration Files

- **`.zshrc`** - Zsh configuration with:
  - Oh My Zsh integration
  - Custom functions (date formatting, translation)
  - FZF (fuzzy finder) configuration
  - Package manager mirror settings (NPM, Pip, Rust)
  - Proxy configuration
  - Claude AI aliases

- **`.config/`** - Application-specific configurations:
  - River (Wayland compositor)
  - i3status-rust (status bar)
  - fcitx5 (input method)
  - newsboat (RSS reader)
  - foot (terminal)
  - and more...

## Key Features

### Development Environment

- **Languages**: Python 3, Node.js (via fnm), Rust, C/C++
- **Editors**: Neovim, VS Code
- **Tools**: Git, Docker, kubectl, fzf

### Shell Enhancements

- **Oh My Zsh** with plugins: git, sudo, docker, kubectl, history, colored-man-pages, fzf
- **Custom functions**:
  - `mydate` - Custom date formatting
  - `tododate` - Todo-friendly date format
  - `tozh` / `toen` - Quick translation functions

### Package Manager Mirrors

Configured mirrors for faster downloads in China:

- **Node/NPM**: npmmirror.com
- **Python/pip**: pypi.tuna.tsinghua.edu.cn
- **Rust**: mirrors.ustc.edu.cn

## Usage

### Applying Configuration

The configuration files in this repository can be:

1. Symlinked to your home directory
2. Managed with a dotfiles manager like GNU Stow
3. Manually copied to the appropriate locations

### NixOS-Specific Setup

If you're using NixOS, see [.nix/README.md](.nix/README.md) for system configuration details.

### Shell Configuration

After updating `.zshrc`, reload the configuration:

```bash
source ~/.zshrc
```

## System Information

- **OS**: Arch Linux
- **Shell**: Zsh with Oh My Zsh
- **Display Protocol**: Wayland
- **Compositor**: River
- **Input Method**: Fcitx5
- **Time Zone**: Asia/Hong_Kong
