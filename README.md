# header42.nvim

École 42's header plugin written in Lua

```
# ************************************************************************** #
#                                                                            #
#                                                        :::      ::::::::   #
#   api.lua                                            :+:      :+:    :+:   #
#                                                    +:+ +:+         +:+     #
#   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        #
#                                                +#+#+#+#+#+   +#+           #
#   Created: 2023/01/13 09:30:28 by vgoncalv          #+#    #+#             #
#   Updated: 2023/01/13 09:30:28 by vgoncalv         ###   ########.fr       #
#                                                                            #
# ************************************************************************** #
```

## Installation
<details><summary>Using lazy.nvim</summary>

header42.nvim LazySpec:

```lua
local spec = {
	"vinicius507/header42.nvim",
}
```
</details>

<details><summary>Using Packer</summary>

```lua
use({
	"vinicius507/header42.nvim",
})
```
</details>

## Setup
To use header42.nvim, you need to set your Intra `login` and `email`:

```lua
local header = require('header42')

header.setup({
	login = "marvin",
	email = "marvin@42.fr",
})
```

## API
Header42 exposes a public API for settings autocmds/keymaps.

### `norme.api.insert`
Inserts an École 42 Header at the current buffer
