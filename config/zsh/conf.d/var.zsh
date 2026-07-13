
export TERMINAL="st"
export EDITOR="nvim"
export VISUAL="nvim"
local rgrc="$HOME/.ripgreprc"
[[ -f "$rgrc" ]] && export RIPGREP_CONFIG_PATH="$rgrc"
export PYTHONPYCACHEPREFIX="/tmp/__pycache__/"

# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_CONFIG_HOME="$HOME/.config"
# export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_CACHE_HOME="$HOME/.cache"

local _ANDROID_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/android"
if [[ -d "$_ANDROID_HOME" ]]; then
  export ANDROID_HOME="$_ANDROID_HOME"
fi
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nv"
# export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/docker"
