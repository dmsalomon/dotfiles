
omzplug=(colored-man-pages git systemd)
for plug in $omzplug; do
	zinit snippet "OMZP::${plug}"
done

omzlib=(
	clipboard completion correction directories
	functions git grep history key-bindings misc
	nvm prompt_info_functions spectrum termsupport
	theme-and-appearance
)
for f in $omzlib; do
	zinit snippet "OMZ::lib/${f}.zsh"
done

