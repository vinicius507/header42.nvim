-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   log.lua                                            :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2023/01/13 10:12:58 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 10:12:58 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

local log_levels = {
	debug = vim.log.levels.DEBUG,
	error = vim.log.levels.ERROR,
	info = vim.log.levels.INFO,
	warn = vim.log.levels.WARN,
}

---@alias LogLevel
---|"debug"
---|"error"
---|"info"
---|"warn"

---@type fun(level: LogLevel, msg: string, ...)
local function log(level, msg, ...)
	vim.notify_once(string.format(msg, ...), log_levels[level], {
		title = "Header42.nvim",
	})
end

setmetatable(M, {
	__index = function(_, key)
		local levels = vim.tbl_keys(log_levels)

		if vim.tbl_contains(levels, key) then
			return function(msg, ...)
				log(key, msg, ...)
			end
		end
	end,
})

---@cast M table<LogLevel, fun(msg: string, ...)>
return M
