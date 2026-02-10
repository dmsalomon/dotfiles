return {
	{
		"snacks.nvim",
		opts = {
			dashboard = { enabled = false },
			indent = { enabled = false },
			image = { enabled = true },
			-- notifier = { enabled = false },
			scroll = { enabled = false },
			terminal = {
				win = {
					keys = {
						term_normal = {
							"<esc>",
						},
						hide_slash = {
							"<C-/>",
						},
					},
				},
			},
		},
	},
}
