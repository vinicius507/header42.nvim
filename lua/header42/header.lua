-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 15:21:50 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

local TEMPLATE = {
	"**************************************************************************",
	"                                                                          ",
	"                                                       :::      ::::::::  ",
	"  @FILENAME..................................        :+:      :+:    :+:  ",
	"                                                   +:+ +:+         +:+    ",
	"  By: @AUTHOR................................    +#+  +:+       +#+       ",
	"                                               +#+#+#+#+#+   +#+          ",
	"  Created: @CREATED_AT........ by @CREATED_BY       #+#    #+#            ",
	"  Updated: @UPDATED_AT........ by @UPDATED_BY      ###   ########.fr      ",
	"                                                                          ",
	"**************************************************************************",
}

---@class HeaderData
---@field filename string
---@field author string
---@field created_at string
---@field created_by string
---@field updated_at string
---@field updated_by string
---@field delimeters string[]

---Creates a new École 42 Header
---@type fun(opts: HeaderData): string[]
function M.new(opts)
	local header = vim.tbl_map(function(line)
		-- Substitute each @KEY by its respective value
		line = string.gsub(line, "(@([%w_]*)%.*)", function(match, key)
			local data = opts[key:lower()]

			if data:len() < match:len() then
				local gap = match:len() - data:len()
				data = data .. string.rep(" ", gap)
			end

			return data
		end)

		-- Add the header delimeters to the line and return it
		return string.format("%s %s %s", opts.delimeters[1], line, opts.delimeters[2])
	end, TEMPLATE)

	-- Append an empty line to the header
	header[#header + 1] = ""

	return header
end

---@param str string
local function escape(str)
	-- Honestly, thanks to: https://stackoverflow.com/questions/6705872/how-to-escape-a-variable-in-lua
	local magic_chars = "%p"
	local esacaped_str, _ = string.gsub(str, magic_chars, "%%%1")

	return esacaped_str
end

---@type fun(lines: string[]): boolean
function M.is_header(lines)
	if #lines < 11 then
		return false
	end

	for lineno = 1, #lines do
		local line = string.gsub(lines[lineno], "[^%s]+ (.*) [^%s]+", "%1")

		-- Escape punctuation chars
		local template_line = string.gsub(TEMPLATE[lineno] or "", "[+*]", "%%%1")

		local range = { string.find(template_line, "@[%w_]*%.*") }
		local has_annotations = range ~= 0

		if has_annotations then
			template_line = string.gsub(template_line, "@[%w_]*%.*", function(annotation)
				return string.rep(".", annotation:len())
			end)
		end

		if not string.match(line, template_line) then
			return false
		end
	end

	return true
end

---Retrieves the data from an existing École 42 Header
---@type fun(header: string): HeaderData
function M.get_data(header)
	---@type table<string, any>
	local data = {
		delimeters = {
			string.match(header, "^([^%s]+).-([^%s]+)\n$"),
		},
	}
	local header_lines = vim.fn.split(header, "\n")
	for lineno = 1, #TEMPLATE do
		-- We add the delimeters from the header to the substitution pattern so we
		-- can remove them
		local line = string.gsub(
			header_lines[lineno],
			string.format("%s (.*) %s", unpack(vim.tbl_map(escape, data.delimeters))),
			"%1"
		)
		local template_line = TEMPLATE[lineno]

		for annotation, key in string.gmatch(template_line, "(@([%w_]+)%.*)") do
			key = key:lower()
			local range = { string.find(template_line, annotation) }

			data[key] = vim.fn.trim(string.sub(line, unpack(range)))
		end
	end

	return data
end

return M
