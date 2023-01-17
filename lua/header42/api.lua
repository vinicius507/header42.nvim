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

local M = {}

local Header = require("header42.header")

---@type fun(opts?: HeaderData)
function M.insert(opts)
	local header = Header:new(opts)

	vim.api.nvim_buf_set_lines(header.bufnr, 0, 0, false, header:lines())
end

---@type fun(opts?: HeaderData, insert_on_empty?: boolean)
function M.update(opts, insert_on_empty)
	opts = opts or {}

	local present = Header:frombuffer(opts.bufnr)

	if present == nil then
		if insert_on_empty == true then
			M.insert(opts)
		end
		return
	end

	if present ~= nil then
		opts = vim.tbl_extend("keep", opts, {
			created_at = present.created_at,
			created_by = present.created_by,
		})
	end

	local header = Header:new(opts)
	vim.api.nvim_buf_set_lines(header.bufnr, 0, 12, false, header:lines())
end

return M
