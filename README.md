# header42.nvim

École 42's header plugin written in Lua

```
-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   api.lua                                            :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2023/01/13 15:19:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/17 18:46:09 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --
```

## Usage
### Installation

You can install the plugin using your favorite plugin manager.

<details><summary>Using lazy.nvim</summary>

```lua
{
	"vinicius507/header42.nvim",
	opts = {
		login = "marvin",
		email = "marvin@42.fr",
	}
}
```
</details>

<details><summary>Using Packer</summary>

```lua
use({
	"vinicius507/header42.nvim",
	config = function()
		require("header42").setup({
			login = "marvin",
			email = "marvin@42.fr",
		})
	end,
})
```
</details>

### Inserting/Updating the header

You can insert or update the header using the following `Stdheader` command:

```vim
:Stdheader
```
