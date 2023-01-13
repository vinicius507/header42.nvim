-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   api.lua                                            :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2023/01/13 15:19:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 18:18:08 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

local Header = require("header42.header")

---@param bufnr? integer
---@param opts? HeaderData
function M.insert(bufnr, opts)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	local header = Header.new(bufnr, opts)

	-- Neodev thinks that the second parameter to append can only be a string
	vim.fn.append(0, header:lines()) ---@diagnostic disable-line
end

---@param bufnr? integer
---@param insert_on_empty? boolean
function M.update(bufnr, insert_on_empty)
	bufnr = bufnr or vim.api.nvim_get_current_buf()

	---@type HeaderData
	local opts
	local present = Header.frombuffer(bufnr)

	if present == nil and not insert_on_empty then
		return
	end

	if present ~= nil then
		opts = {
			created_at = present.created_at,
			created_by = present.created_by,
		}
	end

	local header = Header.new(bufnr, opts)
	vim.api.nvim_buf_set_lines(bufnr, 0, 12, false, header:lines())
end

return M
