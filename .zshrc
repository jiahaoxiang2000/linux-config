# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Add cargo (Rust) bin to PATH
export PATH=$HOME/.cargo/bin:$PATH

# Add pipx local bin to PATH
export PATH=$HOME/.local/bin:$PATH

# Add custom sh local bin to PATH
export PATH=$HOME/.sh:$PATH

# Add npm global bin to PATH
export PATH=$HOME/.npm-global/bin:$PATH

# Add bun gloabl bin to PATH
export PATH="$HOME/.bun/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git sudo docker kubectl history colored-man-pages fzf)

# Add custom completions directory to fpath (before sourcing oh-my-zsh)
fpath=(~/.zsh/completions $fpath)

source $ZSH/oh-my-zsh.sh

# Setup zoxide on your shell
eval "$(zoxide init zsh)"

# ============================================================================
# USER CONFIGURATION
# ============================================================================

# History configuration
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=50000

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

# Input method configuration for IBus/fcitx with Electron apps like VSCode
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

# ============================================================================
# PROXY CONFIGURATION
# ============================================================================

# Global proxy settings
# export http_proxy=http://192.168.71.202:7890
# export https_proxy=http://192.168.71.202:7890
# export HTTP_PROXY=http://192.168.71.202:7890
# export HTTPS_PROXY=http://192.168.71.202:7890
# export no_proxy=localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12

# ============================================================================
# PACKAGE MANAGER INTEGRATIONS
# ============================================================================

# Node and NPM mirror configuration for Chinese users
export FNM_NODE_DIST_MIRROR=https://npmmirror.com/mirrors/node
export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

# Python/pip mirror configuration
export PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

# Rust/cargo mirror configuration
export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

# Maven mirror configuration
export MAVEN_OPTS="-Dmaven.repo.local=$HOME/.m2/repository"
alias mvn='mvn -s $HOME/.m2/settings.xml'

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

# Source fzf key bindings and completion
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

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
    # trans-cli "$@"
    trans --target-lang zh_CN "$@"
}

# Translation from Chinese to English function
function toen() {
    # trans-cli -f zh -t en "$@"
    trans --target-lang en "$@"
}

# ============================================================================
# CLAUDE FUNCTIONS
# ============================================================================

# Source token file if it exists (makes LLM API tokens available)
[[ -f ~/.token ]] && source ~/.token

# Original Claude with proxy settings
alias claude='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'
# alias claude-proxy='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'

# Codex routed through the same local proxy
alias codex-proxy='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 codex'

# OpenCode with proxy settings (SOCKS5 via SSH tunnel)
alias opencode-proxy='HTTPS_PROXY=http://localhost:1080 opencode'

# Claude with DeepSeek API
alias claude-deepseek='source ~/.token && ANTHROPIC_AUTH_TOKEN=$DEEPSEEK_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" ANTHROPIC_MODEL="deepseek-chat" CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-chat" ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat" /home/isomo/.npm-global/bin/claude'

# Claude with Kimi (Moonshot) API
alias claude-kimi='source ~/.token && ANTHROPIC_AUTH_TOKEN=$KIMI_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic" ANTHROPIC_MODEL="kimi-k2-turbo-preview" ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" /home/isomo/.npm-global/bin/claude'

# Claude with BigModel API
alias claude-bigmodel='source ~/.token && ANTHROPIC_AUTH_TOKEN=$BIGMODEL_AUTH_TOKEN ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic" API_TIMEOUT_MS=3000000 CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.6" /home/isomo/.npm-global/bin/claude'

# Qwen with Bailian API
alias qwen-bailian='source ~/.token && OPENAI_API_KEY=$QWEN_AUTH_TOKEN OPENAI_BASE_URL="https://dashscope.aliyuncs.com/compatible-mode/v1" OPENAI_MODEL="qwen3-coder-plus" qwen'

