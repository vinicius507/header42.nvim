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

local header = {}

local utils = require('header42.utils')

header.format = header.format or utils.load_format()

local function get_header(ft_config)
	local res = {}
	ft_config = setmetatable(ft_config or {}, {
		__index = function(_, k)
			if k:match('%w+_padding') then
				return '%s+'
			elseif k:match('%w+_date') then
				return '[^%s]+ [^%s]+'
			end
			return '[^%s]+'
		end,
	})
	for _, line in ipairs(header.format) do
		res[#res + 1] = string.gsub(line, '{%s*([%w_]+)%s*}', ft_config)
	end
	return res
end

function header.is_present()
	local format = get_header()
	local lines = vim.api.nvim_buf_get_lines(0, 0, 11, 0)
	if #format ~= #lines then
		return false
	end
	for linenum, line in ipairs(lines) do
		if not string.match(line, format[linenum]) then
			return false
		end
	end
	return true
end

return header
