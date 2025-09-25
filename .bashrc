export PATH=$HOME/.npm-global/bin:$HOME/.local/bin:$PATH

export http_proxy=http://192.168.71.202:7890
export https_proxy=http://192.168.71.202:7890

export CARGO_TARGET_DIR=$HOME/.local/bin

# Proxy settings for Claude Code only
alias claude='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'
