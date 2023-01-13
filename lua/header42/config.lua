-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   config.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:40 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 10:13:06 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

---@class FtHeaderConfig
local defaults = {
	---@type string
	login = "marvin",
	---@type string
	email = "marvin@42.fr",
}

---@type FtHeaderConfig
local settings

---@type fun(opts: FtHeaderConfig?)
function M.setup(opts)
	settings = vim.tbl_extend("force", defaults, opts or {})

	vim.api.nvim_create_user_command("Stdheader", function()
		require("header42.api").update(true)
	end, {})
end

setmetatable(M, {
	__index = function(_, key)
		if settings == nil then
			M.setup()
		end

		---@cast settings FtHeaderConfig
		return settings[key]
	end,
})

---@cast M +FtHeaderConfig
return M
