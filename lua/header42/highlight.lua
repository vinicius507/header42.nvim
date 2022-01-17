-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   highlight.lua                                      :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/12/27 05:38:50 by vgoncalv          #+#    #+#             --
--   Updated: 2022/01/07 08:25:34 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local M = {}

local highlight = vim.highlight

local header = require('header42.header')
local utils = require('header42.utils')

local function highlight_varwords(hl, word, line, linenum)
	if word == nil then
		utils.errorf("could not find target fot hl '%s'", hl)
		return
	end
	local start, _ = string.find(line, word)
	highlight.range(
		0,
		vim.api.nvim_get_namespaces()['header42'],
		hl,
		{ linenum - 1, start - 1 },
		{ linenum - 1, start + string.len(word) - 1 },
		'c'
	)
end

local function highlight_fixed(hl, start, _end)
	highlight.range(
		0,
		vim.api.nvim_get_namespaces()['header42'],
		hl,
		start,
		_end,
		'b'
	)
end

local function highlight_logo()
	local linenum = 2
	while linenum <= 8 do
		highlight_fixed('Header42Logo', { linenum, 50 }, { linenum, 75 })
		linenum = linenum + 1
	end
end

function M.highlight()
	local format = header.get_header()
	for l, fmt in ipairs(format) do
		format[l] = fmt:gsub('[^%]s][+]', function(s)
			return string.sub(s, 1, 1) .. '.'
		end)
	end
	local current = vim.api.nvim_buf_get_lines(0, 0, 11, 0)
	local fname = string.match(current[4], format[4])
	local il, im = string.match(current[6], format[6])
	local il2 = string.match(current[9], 'by ([^%s]+)')
	highlight_logo()
	highlight_fixed('Header42', { 0, 0 }, { 10, 80 })
	highlight_fixed('Header42Date', { 7, 14 }, { 7, 33 })
	highlight_fixed('Header42Date', { 8, 14 }, { 8, 33 })
	highlight_varwords('Header42Filename', fname, current[4], 4)
	highlight_varwords('Header42Author', il, current[6], 6)
	highlight_varwords('Header42Author', il, current[8], 8)
	highlight_varwords('Header42Author', il2, current[9], 9)
	highlight_varwords('Header42Mail', im, current[6], 6)
end

function M.highlight_update()
	local format = header.get_header()
	for l, fmt in ipairs(format) do
		format[l] = fmt:gsub('[^%]s][+]', function(s)
			return string.sub(s, 1, 1) .. '.'
		end)
	end
	local current = vim.api.nvim_buf_get_lines(0, 0, 11, 0)
	local fname = string.match(current[4], format[4])
	local il = string.match(current[9], 'by ([^%s]+)')
	highlight_logo()
	highlight_fixed('Header42', { 3, 0 }, { 3, 80 })
	highlight_fixed('Header42', { 8, 0 }, { 8, 80 })
	highlight_fixed('Header42Date', { 8, 14 }, { 8, 33 })
	highlight_varwords('Header42Filename', fname, current[4], 4)
	highlight_varwords('Header42Author', il, current[9], 9)
end

return M
