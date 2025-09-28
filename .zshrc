# ============================================================================
# ZSH CORE CONFIGURATION
# ============================================================================

# History configuration
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000
bindkey -e

# Completion system
zstyle :compinstall filename '/home/isomo/.zshrc'
autoload -Uz compinit
compinit

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Input method configuration for IBus/fcitx with Electron apps like VSCode
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# Display scaling configuration
export QT_FONT_DPI=120
export QT_SCALE_FACTOR=0.8

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Add cargo (Rust) bin to PATH
export PATH=$HOME/.cargo/bin:$PATH

# Add pipx local bin to PATH
export PATH=$HOME/.local/bin:$PATH

# Add npm global bin to PATH
export PATH=$HOME/.npm-global/bin:$PATH

# ============================================================================
# PROXY CONFIGURATION
# ============================================================================

# Global proxy settings
export http_proxy=http://192.168.71.202:7890
export https_proxy=http://192.168.71.202:7890
export no_proxy=localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12

# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

# Custom date format function - formats date in YYYY-MM-DD HH:MM:SS TZ format (24-hour, no weekday)
function mydate() {
    date +"%Y-%m-%d %H:%M:%S %Z %a"
}

function tododate() {
    date +"%Y-%m-%d %a"
}

# Quick translation to Chinese function
function tozh() {
    trans-cli "$@"
}

# Translation from Chinese to English function
function toen() {
    trans-cli -f zh -t en "$@"
}

# ============================================================================
# CLAUDE FUNCTIONS
# ============================================================================

# Original Claude with proxy settings
alias claude='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'

# Codex routed through the same local proxy
alias codex='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 codex'

# Claude with DeepSeek API
alias claude-deepseek='source ~/.token && ANTHROPIC_AUTH_TOKEN=$DEEPSEEK_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" ANTHROPIC_MODEL="deepseek-chat" ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat" claude'

# Claude with Kimi (Moonshot) API
alias claude-kimi='source ~/.token && ANTHROPIC_AUTH_TOKEN=$KIMI_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.moonshot.cn/v1" ANTHROPIC_MODEL="kimi-k2-0905-preview" ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-0905-preview" claude'

# Claude with BigModel API
alias claude-bigmodel='source ~/.token && ANTHROPIC_AUTH_TOKEN=$BIGMODEL_AUTH_TOKEN ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic" ANTHROPIC_MODEL="GLM-4.5" ANTHROPIC_SMALL_FAST_MODEL="GLM-4.5-Air" claude'

# ============================================================================
# PACKAGE MANAGER INTEGRATIONS
# ============================================================================

# Node and NPM mirror configuration for Chinese users
export FNM_NODE_DIST_MIRROR=https://npmmirror.com/mirrors/node
export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# ============================================================================
# FZF CONFIGURATION
# ============================================================================

# Enhanced fuzzy finder with item numbers and previews
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --multi --preview-window=:hidden"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --height 60%"
export FZF_CTRL_T_OPTS="--preview 'tree -C {} 2> /dev/null || ls -la {}' --height 60%"
export FZF_ALT_C_OPTS="--preview 'bat --style=numbers --color=always {} 2> /dev/null || cat {}' --height 60%"

# Custom FZF commands to swap Ctrl+T (folders) and Alt+C (files)
export FZF_CTRL_T_COMMAND="find . -type d"
export FZF_ALT_C_COMMAND="find . -type f"
