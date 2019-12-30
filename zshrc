
source ~/.zplug/init.zsh

export ZSH_CACHE_DIR=~/.cache/zsh

zplug "lib/*", from:oh-my-zsh
zplug "plugins/zsh_reload", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/systemd", from:oh-my-zsh

zplug "agkozak/zsh-z"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "~/.zsh", from:local

zplug load

source ~/.zsh/themes/dovi.zsh-theme

export PATH="$PATH:$HOME/.scripts"
export PATH="$HOME/.cargo/bin:$PATH"
