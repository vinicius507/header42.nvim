-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/18 09:24:54 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

---@class Header
---@field bufnr integer
---@field filename string
---@field author Author
---@field delimeters string[]
---@field created_at string
---@field created_by string
---@field updated_at string
---@field updated_by string
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

---@class Author
---@field login string
---@field email string
local Author = {}

---@type fun(self: Author, login: string, email: string): Author
function Author:new(login, email)
	local o = {
		login = login,
		email = email,
	}
	return setmetatable(o, { __index = self, __tostring = self.tostring })
end

---@param str string
function Author:fromstring(str)
	local login, email = string.match(str, "^[^%s]+ <^%s+>$")

	if not login or not email then
		return nil
	end

	return self:new(login, email)
end

---@type fun(self: Author): string
function Author:tostring()
	return string.format("%s <%s>", self.login, self.email)
end

---@alias HeaderData Header
---@alias HeaderField number|string|string[]|Author
---@alias HeaderFieldKey
---|"bufnr"
---|"filename"
---|"author"
---|"delimeters"
---|"created_at"
---|"created_by"
---|"updated_at"
---|"updated_at"

---@type fun(bufnr: integer): string[]
local function buf_delimeters(bufnr)
	local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
	return delimeters[ft] or delimeters.default
end

---@type fun(bufnr: integer): string
local function buf_filename(bufnr)
	local filename = vim.api.nvim_buf_get_name(bufnr)
	return vim.fn.fnamemodify(filename, ":t")
end

---@type fun(): string
local function created_at()
	return vim.fn.strftime("%Y/%m/%d %H:%M:%S")
end

setmetatable(M, {
	---@type fun(self: Header, field: HeaderFieldKey): HeaderField
	__index = function(self, field)
		if field == "author" then
			return Author:new(config.login, config.email)
		elseif field == "bufnr" then
			return vim.api.nvim_get_current_buf()
		elseif field == "delimeters" then
			return buf_delimeters(self.bufnr)
		elseif field == "filename" then
			return buf_filename(self.bufnr)
		elseif field == "created_at" then
			return created_at()
		elseif field == "created_by" then
			return config.login
		elseif field == "updated_at" then
			return self.created_at
		elseif field == "updated_by" then
			return config.login
		end
		return self[field]
	end,
	---@type fun(self: Header, field: HeaderFieldKey, value: HeaderField)
	__newindex = function(self, field, value)
		if field == "author" and type(value) == "string" then
			---@cast value string
			rawset(self, field, Author:fromstring(value))
		else
			rawset(self, field, value)
		end
	end,
})

---Creates a new École 42 Header
---@type fun(self: Header, opts?: HeaderData): Header
function M:new(opts)
	return setmetatable(opts or {}, { __index = self })
end

---@param line string
---@param delim string[]
local function add_delimeters(line, delim)
	line = string.sub(line, delim[1]:len() + 2, line:len() - delim[2]:len() - 1)
	return string.format("%s %s %s", delim[1], line, delim[2])
end

---@return string[]
function M:lines()
	local lines = vim.tbl_map(function(template_line)
		return add_delimeters(template_line, self.delimeters)
	end, TEMPLATE)
	local annotated_lines = { 4, 6, 8, 9 }

	for _, lineno in ipairs(annotated_lines) do
		lines[lineno] = string.gsub(lines[lineno], "(@([%w_]*)%.*)", function(match, key)
			key = key:lower()
			local data = tostring(self[key])
			local pad = string.rep(" ", match:len() > data:len() and match:len() - data:len() or 0)
			return string.format("%s%s", data, pad)
		end)
	end

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

	local annotated_lines = { 4, 6, 8, 9 }
	local lines_delimeters = { string.match(lines[1], "^([^%s]+) .* ([^%s]+)$") }

	if #lines_delimeters == 0 then
		return false
	end

	for lineno, template_line in ipairs(TEMPLATE) do
		local line = lines[lineno]
		template_line = add_delimeters(template_line, lines_delimeters)

		if vim.tbl_contains(annotated_lines, lineno) then
			template_line = string.gsub(template_line, "@[%w_]+%.*", function(match)
				local range = { string.find(template_line, match, 1, true) }
				return string.sub(line, unpack(range))
			end)
		end

		template_line = string.gsub(template_line, "[+*]", "%%%1")

		if not string.match(line, template_line) then
			return false
		end
	end

	return true
end

---Retrieves the data from an existing École 42 Header
---@type fun(self: Header, bufnr: integer): Header?
function M:frombuffer(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 12, false)

	if not lines_are_header(lines) then
		return
	end

	---@type table<string, any>
	local opts = {
		bufnr = bufnr,
		delimeters = {
			string.match(lines[1], "^([^%s]+) .- ([^%s]+)$"),
		},
	}

	for lineno, template_line in ipairs(TEMPLATE) do
		local line = lines[lineno]

		for annotation, key in string.gmatch(template_line, "(@([%w_]+)%.*)") do
			key = key:lower()
			local range = { string.find(template_line, annotation) }

			opts[key] = vim.fn.trim(string.sub(line, unpack(range)))
		end
	end

	return self:new(opts)
end

return M
