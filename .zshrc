# ============================================================================
# PLATFORM DETECTION
# ============================================================================

case "$OSTYPE" in
    darwin*)
        IS_MACOS=1
        IS_LINUX=0
        ;;
    linux*)
        IS_MACOS=0
        IS_LINUX=1
        ;;
    *)
        IS_MACOS=0
        IS_LINUX=0
        ;;
esac

# ============================================================================
# PATH CONFIGURATION
# ============================================================================

# Homebrew (macOS only)
if [[ "$IS_MACOS" == 1 ]] && [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# User-local tools
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.sh:$PATH"
export PATH="$HOME/.bun:$PATH"
export PATH="$HOME/.bun/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"

# Homebrew-managed Node.js (macOS only)
if [[ "$IS_MACOS" == 1 ]] && [[ -d /opt/homebrew/opt/node@24/bin ]]; then
    export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# ============================================================================
# OH MY ZSH
# ============================================================================

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled
# zstyle ':omz:update' mode auto
# zstyle ':omz:update' mode reminder

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
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
plugins=(git sudo docker kubectl history colored-man-pages fzf)

# ============================================================================
# COMPLETION CONFIGURATION
# ============================================================================

# Add custom completions directory to fpath (before sourcing oh-my-zsh)
fpath=("$HOME/.zsh/completions" $fpath)

# Add bun completion directory to fpath if available
if [[ -f "$HOME/.oh-my-zsh/completions/_bun" ]]; then
    fpath=("$HOME/.oh-my-zsh/completions" $fpath)
fi

source "$ZSH/oh-my-zsh.sh"

# fzf completion
if [[ "$IS_MACOS" == 1 ]] && [[ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/completion.zsh
elif [[ -f /usr/share/fzf/completion.zsh ]]; then
    source /usr/share/fzf/completion.zsh
fi

# Setup zoxide on your shell
eval "$(zoxide init zsh)"

# ============================================================================
# USER CONFIGURATION
# ============================================================================

# History configuration
HISTFILE="$HOME/.histfile"
HISTSIZE=10000
SAVEHIST=50000

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export EDITOR=nvim

# Input method configuration for IBus/fcitx with Electron apps like VSCode
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

if [[ "$IS_LINUX" == 1 ]]; then
    # Node and NPM mirror configuration for Chinese users
    export FNM_NODE_DIST_MIRROR=https://npmmirror.com/mirrors/node
    export NPM_CONFIG_REGISTRY=https://registry.npmmirror.com

    # Python/pip mirror configuration
    export PIP_INDEX_URL=https://pypi.tuna.tsinghua.edu.cn/simple

    # Rust/cargo mirror configuration
    export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
    export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
fi

# Maven configuration
export MAVEN_OPTS="-Dmaven.repo.local=$HOME/.m2/repository"
alias mvn='mvn -s $HOME/.m2/settings.xml'

# ============================================================================
# FZF CONFIGURATION
# ============================================================================

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --info=inline --multi --preview-window=:hidden"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --height 60%"
export FZF_CTRL_T_OPTS="--preview 'tree -C {} 2> /dev/null || ls -la {}' --height 60%"
export FZF_ALT_C_OPTS="--preview 'bat --style=numbers --color=always {} 2> /dev/null || cat {}' --height 60%"

# Custom FZF commands to swap Ctrl+T (folders) and Alt+C (files)
export FZF_CTRL_T_COMMAND="find . -type d"
export FZF_ALT_C_COMMAND="find . -type f"

# fzf key bindings
if [[ "$IS_MACOS" == 1 ]] && [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
fi

# Node version manager
if [[ -f /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
elif [[ -f "$HOME/.nvm/nvm.sh" ]]; then
    source "$HOME/.nvm/nvm.sh"
fi

# ============================================================================
# CUSTOM FUNCTIONS
# ============================================================================

function mydate() {
    date +"%Y%m%d %H:%M:%S %Z %a"
}

function tododate() {
    date +"%Y%m%d %a"
}

function tozh() {
    trans --target-lang zh_CN "$@"
}

function toen() {
    trans --target-lang en "$@"
}

# ============================================================================
# SYSTEMD USER UNITS
# ============================================================================

# Show enabled + running systemd user services that expose a URL (concise).
function sysu() {
    emulate -L zsh
    setopt local_options no_xtrace no_verbose null_glob

    [[ "$IS_LINUX" == 1 ]] || { print -u2 "sysu: systemd user units are Linux-only"; return 1 }

    local dir="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
    local -a units=("$dir"/*.service)
    (( $#units )) || { print "sysu: no user units in $dir"; return 0 }
    units=(${units:t})

    local u cg procfile
    local -a pids ports urls
    for u in $units; do
        systemctl --user is-enabled --quiet "$u" 2>/dev/null || continue
        systemctl --user is-active --quiet "$u" || continue
        cg=$(systemctl --user show -p ControlGroup --value "$u" 2>/dev/null)
        procfile="/sys/fs/cgroup${cg}/cgroup.procs"
        pids=(); ports=(); urls=()
        [[ -r "$procfile" ]] && pids=(${(f)"$(<$procfile)"})
        if (( $#pids )) && (( $+commands[ss] )); then
            ports=(${(fu)"$(ss -tlnp 2>/dev/null | awk -v re="pid=(${(j:|:)pids})," '$0 ~ re {n=split($4,a,":"); print a[n]}' | sort -un)"})
        fi
        (( $#ports )) || continue
        urls=("http://localhost:"${^ports})
        printf '  %-18s %s\n' "${u%.service}" "${(j:  :)urls}"
    done
}

# ============================================================================
# LLM TOOLS
# ============================================================================

# Source token file if it exists
[[ -f "$HOME/.token" ]] && source "$HOME/.token"

# GitHub MCP authentication from the GitHub CLI credential store
if (( $+commands[gh] )); then
    _github_mcp_token="$(gh auth token 2>/dev/null)"
    [[ -n "$_github_mcp_token" ]] && export GITHUB_PERSONAL_ACCESS_TOKEN="$_github_mcp_token"
    unset _github_mcp_token
fi

# Short alias for Claude Code
alias cc='claude'

# Claude with proxy settings
# alias claude='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'

# Codex routed through the same local proxy
alias codex-proxy='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 codex'

# OpenCode with proxy settings
alias opencode-proxy='HTTPS_PROXY=http://localhost:1080 opencode'
# Short aliases for OpenCode
alias oc='opencode2'
alias ocp='opencode-proxy'
# OpenCode: enable experimental workspace support
export OPENCODE_EXPERIMENTAL_WORKSPACES=true

# Claude with DeepSeek API
alias claude-deepseek='ANTHROPIC_AUTH_TOKEN=$DEEPSEEK_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic" ANTHROPIC_MODEL="deepseek-chat" CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-chat" ANTHROPIC_SMALL_FAST_MODEL="deepseek-chat" $HOME/.local/bin/claude'

# Claude with Kimi (Moonshot) API
alias claude-kimi='ANTHROPIC_AUTH_TOKEN=$KIMI_AUTH_TOKEN ANTHROPIC_BASE_URL="https://api.moonshot.cn/anthropic" ANTHROPIC_MODEL="kimi-k2-turbo-preview" ANTHROPIC_SMALL_FAST_MODEL="kimi-k2-turbo-preview" $HOME/.local/bin/claude'

# Claude with BigModel API
alias ccg='ANTHROPIC_AUTH_TOKEN=$BIGMODEL_AUTH_TOKEN ANTHROPIC_BASE_URL="https://open.bigmodel.cn/api/anthropic" API_TIMEOUT_MS=3000000 CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1 ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.7" $HOME/.local/bin/claude'

# Qwen with Bailian API
alias qwen-bailian='OPENAI_API_KEY=$QWEN_AUTH_TOKEN OPENAI_BASE_URL="https://dashscope.aliyuncs.com/compatible-mode/v1" OPENAI_MODEL="qwen3-coder-plus" qwen'

# Claude with MiMo API
alias claude-mimo='ANTHROPIC_AUTH_TOKEN=$MIMO_API_KEY ANTHROPIC_BASE_URL="https://api.xiaomimimo.com/anthropic" ANTHROPIC_DEFAULT_OPUS_MODEL="mimo-v2-flash" ANTHROPIC_DEFAULT_SONNET_MODEL="mimo-v2-flash" ANTHROPIC_DEFAULT_HAIKU_MODEL="mimo-v2-flash" $HOME/.local/bin/claude'

# bun completions
[ -s "$HOME/.oh-my-zsh/completions/_bun" ] && source "$HOME/.oh-my-zsh/completions/_bun"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/isomoes/.opam/opam-init/init.zsh' ]] || source '/home/isomoes/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
