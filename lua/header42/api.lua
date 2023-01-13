-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   api.lua                                            :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2023/01/13 15:19:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 15:21:44 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

local log = require("header42.log")
local config = require("header42.config")
local ftheader = require("header42.header")

function M.insert()
	local author = string.format("%s <%s>", config.login, config.email)
	local filename = vim.fn.expand("%:t")
	local insertion_date = vim.fn.strftime("%Y/%m/%d %H:%M:%S")

	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	local delimeters = require("header42.delimeters")[ft]

	if delimeters == nil then
		log.error("Unsupported filetype: %s", ft)
		return
	end

	local header = ftheader.new({
		filename = filename,
		author = author,
		created_at = insertion_date,
		created_by = config.login,
		updated_at = insertion_date,
		updated_by = config.login,
		delimeters = delimeters,
	})

	-- Neodev thinks that the second parameter to append can only be a string
	vim.fn.append(0, header) ---@diagnostic disable-line
end

---@param insert_on_empty boolean
function M.update(insert_on_empty)
	local lines = vim.api.nvim_buf_get_lines(0, 0, 12, false)

	if ftheader.is_header(lines) == false then
		if insert_on_empty == true then
			M.insert()
		end
		return
	end

	local header = ftheader.get_data(table.concat(lines, "\n"))
	local header_data = vim.tbl_extend("force", header, {
		filename = vim.fn.expand("%:t"),
		author = string.format("%s <%s>", config.login, config.email),
		updated_at = vim.fn.strftime("%Y/%m/%d %H:%M:%S"),
		updated_by = config.login,
	})

	header = ftheader.new(header_data)
	vim.api.nvim_buf_set_lines(0, 0, 12, false, header)
end

return M
