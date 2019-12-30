local ret_status="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
local pwd_color="%(!.%{$fg[red]%}.%{$fg[blue]%})"
PROMPT='$(hostssh)${ret_status} ${pwd_color}$(prompt_pwd)%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_CLEAN=")"
ZSH_THEME_GIT_PROMPT_DIRTY=") %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
