
source ~/.zplugin/bin/zplugin.zsh
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin

omzlib=(
	bzr clipboard compfix completion correction
	diagnostics directories functions git
	grep history key-bindings misc nvm
	prompt_info_functions spectrum termsupport
	theme-and-appearance
)
for f in $omzlib; do
	zplugin snippet "OMZ::lib/${f}.zsh"
done

zplugin ice wait lucid
zplugin light agkozak/zsh-z

zplugin light zsh-users/zsh-syntax-highlighting
zplugin light zsh-users/zsh-autosuggestions

omzplug=(
	colored-man-pages
	git
	systemd
)
for plug in $omzplug; do
	zplugin ice wait lucid
	zplugin snippet "OMZ::plugins/${plug}/${plug}.plugin.zsh"
done

for f in ~/.zsh/**/*; do
	[[ -d "$f" ]] || zplugin snippet "$f"
done
source ~/.zsh/themes/dovi.zsh-theme

export PATH="$PATH:$HOME/.scripts"
export PATH="$PATH:$HOME/.cargo/bin"
