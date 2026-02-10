
# set if not set
: ${ANTIDOTE_HOME:=${XDG_DATA_HOME:-$HOME/.local/share}/antidote}

ANTIDOTE_REPO="$ANTIDOTE_HOME/antidote.git"

zstyle ':antidote:home' path "$ANTIDOTE_HOME"
zstyle ':antidote:repo' path "$ANTIDOTE_REPO"
zstyle ':antidote:bundle' use-friendly-names 'yes'
zstyle ':antidote:plugin:*' defer-options '-p'
zstyle ':antidote:*' zcompile 'yes'

if [[ ! -d "$ANTIDOTE_REPO" ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git $ANTIDOTE_REPO
fi

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
zsh_plugins=${ZDOTDIR:-~}/.zsh_plugins

# Ensure the .zsh_plugins.txt file exists so you can add plugins.
[[ -f ${zsh_plugins}.txt ]] || touch ${zsh_plugins}.txt

# Lazy-load antidote from its functions directory.
fpath=($ANTIDOTE_REPO/functions $fpath)
autoload -Uz antidote

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! ${zsh_plugins}.zsh -nt ${zsh_plugins}.txt ]]; then
  antidote bundle <${zsh_plugins}.txt >|${zsh_plugins}.zsh
fi

# Source your static plugins file.
source ${zsh_plugins}.zsh
