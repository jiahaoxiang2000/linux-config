export PATH=$HOME/.npm-global/bin:$PATH

export http_proxy=http://192.168.71.202:7890
export https_proxy=http://192.168.71.202:7890
export no_proxy=localhost,127.0.0.1,::1,192.168.0.0/16,10.0.0.0/8,172.16.0.0/12

# Proxy settings for Claude Code only
alias claude='http_proxy=http://localhost:1080 https_proxy=http://localhost:1080 claude'
