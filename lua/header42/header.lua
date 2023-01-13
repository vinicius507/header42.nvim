-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   header.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:30 by vgoncalv          #+#    #+#             --
--   Updated: 2023/01/13 10:12:18 by vgoncalv         ###   ########.fr       --
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

return M
