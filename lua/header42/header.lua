-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2021/12/26 19:35:33 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local M = {}

local fn = vim.fn

local config = require('header42.config')
local utils = require('header42.utils')

---@return string: header42 format
local function load_format()
	local format = {}
	local filepaths = fn.glob(fn.stdpath('data') .. '**/header_format', 0, 1)

	if #filepaths == 0 then
		utils.error(
			"Could not find header_format. Make sure header42.nvim is installed in stdpath('data'"
		)
	end

	for line in io.lines(filepaths[1]) do
		format[#format + 1] = line
	end
	return format
end

M.format = M.format or load_format()

local function get_header(ft_config)
	local header = {}
	ft_config = ft_config or {}
	setmetatable(ft_config, {
		__index = function(t, k)
			if k:match('%w+_padding') then
				local section = k:match('(%w+)_padding')
				if section:match('author') then
					return utils.padding(k, t.intra_login .. t.intra_mail)
				elseif section:match('created') or section:match('updated') then
					return utils.padding(k, t.intra_login)
				end
				return utils.padding(k, t[section])
			elseif k:match('%w+_date') then
				return '[^%s]+ [^%s]+'
			end
			return '[^%s]+'
		end,
	})
	for _, line in ipairs(M.format) do
		header[#header + 1] = string.gsub(line, '{%s*([%w_]+)%s*}', ft_config)
	end
	return header
end

function M.is_present()
	local format = get_header()
	local ok, lines = pcall(vim.api.nvim_buf_get_lines, 0, 0, 11, 0)
	if not ok or #format ~= #lines then
		return false
	end
	for linenum, line in ipairs(lines) do
		local linefmt = format[linenum]:gsub('[^%]s][+]', function(s)
			return string.sub(s, 1, 1) .. '.'
		end)
		if not string.match(line, linefmt) then
			return false
		end
	end
	return true
end

function M.insert()
	local filename = fn.expand('%:t')
	local created_date = fn.strftime('%Y/%m/%d %H:%M:%S')
	local header = get_header({
		filename = filename,
		intra_login = config.intra_login(),
		intra_mail = config.intra_mail(),
		created_date = created_date,
		updated_date = created_date,
		start_comment = config.start_comment(),
		fill_comment = string.rep(config.fill_comment(), 74),
		end_comment = config.end_comment(),
	})
	for linenum, line in ipairs(header) do
		fn.append(linenum - 1, line)
	end
	fn.append(11, '')
end

function M.update()
	local current = vim.api.nvim_buf_get_lines(0, 0, 11, 0)
	local filename = fn.expand('%:t')
	local start_comment, end_comment = current[1]:match(
		'([^%s]+) [^%s]+ ([^%s]+)'
	)
	local header = get_header({
		filename = filename,
		intra_login = config.intra_login(),
		updated_date = fn.strftime('%Y/%m/%d %H:%M:%S'),
		start_comment = start_comment,
		end_comment = end_comment,
	})
	fn.setline(4, header[4])
	fn.setline(9, header[9])
end

return M
