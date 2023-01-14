-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/14 16:38:49 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

---@class Header
---@field filename string
---@field author {login: string, email: string}
---@field created_at string
---@field created_by string
---@field updated_at string
---@field updated_by string
---@field delimeters string[]
local M = {}

local config = require("header42.config")
local delimeters = require("header42.delimeters")

local TEMPLATE = {
	"********************************************************************************",
	"*                                                                              *",
	"*                                                         :::      ::::::::    *",
	"*    @FILENAME..................................        :+:      :+:    :+:    *",
	"*                                                     +:+ +:+         +:+      *",
	"*    By: @AUTHOR................................    +#+  +:+       +#+         *",
	"*                                                 +#+#+#+#+#+   +#+            *",
	"*    Created: @CREATED_AT........ by @CREATED_BY       #+#    #+#              *",
	"*    Updated: @UPDATED_AT........ by @UPDATED_BY      ###   ########.fr        *",
	"*                                                                              *",
	"********************************************************************************",
}

---@alias HeaderData Header

---@param bufnr integer
local function buf_delimeters(bufnr)
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	return delimeters[ft]
end

---@param bufnr integer
local function buf_filename(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	return vim.fn.fnamemodify(filename, ":t")
end

---Creates a new École 42 Header
---@type fun(bufnr: integer, opts?: HeaderData): Header
function M.new(bufnr, opts)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local now = vim.fn.strftime("%Y/%m/%d %H:%M:%S")

	opts = vim.tbl_extend(
		"keep",
		opts or {},
		---@type HeaderData
		{
			author = {
				login = config.login,
				email = config.email,
			},
			delimeters = buf_delimeters(bufnr),
			filename = buf_filename(bufnr),
			created_at = now,
			created_by = config.login,
			updated_at = now,
			updated_by = config.login,
		}
	)

	return setmetatable(opts or {}, { __index = M })
end

---@return string[]
function M:lines()
	local lines = vim.tbl_map(function(line)
		-- Substitute each @KEY by its respective value
		line = string.gsub(line, "(@([%w_]*)%.*)", function(match, key)
			key = key:lower()
			local data = self[key]

			if key == "author" then
				data = string.format("%s <%s>", self.author.login, self.author.email)
			end

			if data:len() < match:len() then
				local gap = match:len() - data:len()
				data = data .. string.rep(" ", gap)
			end

			return data
		end)

		-- Add the header delimeters to the line and return it
		local delimeter_len = string.len(self.delimeters[1])
		return string.format(
			"%s %s %s",
			self.delimeters[1],
			string.sub(line, delimeter_len + 2, line:len() - delimeter_len - 1),
			self.delimeters[2]
		)
	end, TEMPLATE)

	-- Append an empty line to the header
	lines[#lines + 1] = ""
	return lines
end

-- TODO: find a better way to check if lines compose a header

---@type fun(lines: string[]): boolean
local function lines_are_header(lines)
	if #lines < 11 then
		return false
	end

	local lines_delimeter = { string.match(lines[1], "^([^%s]+) .- ([^%s]+)$") }

	if not #lines_delimeter then
		return false
	end

	local delimeter_len = lines_delimeter[1]:len()
	for lineno = 1, #lines do
		local line = lines[lineno]

		if not string.match(line, string.format("^%s .- %s$", unpack(lines_delimeter))) then
			return false
		end

		local template_line = string.format(
			"%s %s %s",
			lines_delimeter[1],
			string.sub(TEMPLATE[lineno], delimeter_len + 2, line:len() - delimeter_len - 1),
			lines_delimeter[2]
		)

		-- Escape punctuation chars
		template_line = string.gsub(template_line or "", "[+*]", "%%%1")

		local range = { string.find(template_line, "@[%w_]*%.*") }
		local has_annotations = range ~= 0

		if has_annotations then
			template_line = string.gsub(template_line, "@[%w_]*%.*", function(annotation)
				return string.rep(".", annotation:len())
			end)
		end

		if not string.match(line, template_line) then
			print(line)
			print(template_line)
			return false
		end
	end

	return true
end

-- TODO: find a better way to extract information from a buffer

---Retrieves the data from an existing École 42 Header
---@type fun(bufnr: integer): Header?
function M.frombuffer(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 11, false)

	local ok = pcall(vim.validate, { lines = { lines, lines_are_header, "École 42 header" } })

	if not ok then
		return nil
	end

	---@type table<string, any>
	local data = {
		delimeters = {
			string.match(lines[1], "^([^%s]+) .- ([^%s]+)$"),
		},
	}
	local delimeter_len = string.len(data.delimeters[1])

	for lineno = 1, #TEMPLATE do
		local line = lines[lineno]
		local template_line = string.format(
			"%s %s %s",
			data.delimeters[1],
			string.sub(TEMPLATE[lineno], delimeter_len + 2, line:len() - delimeter_len - 1),
			data.delimeters[2]
		)

		for annotation, key in string.gmatch(template_line, "(@([%w_]+)%.*)") do
			key = key:lower()
			local range = { string.find(template_line, annotation) }
			local content = vim.fn.trim(string.sub(line, unpack(range)))

			if key == "author" then
				local login, email = string.match(content, "^([^%s]+) <([^%s]+)>")

				data[key] = {
					login = login,
					email = email,
				}
			else
				data[key] = content
			end
		end
	end

	return data
end

return M
