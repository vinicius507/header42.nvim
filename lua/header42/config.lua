-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   config.lua                                         :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/09/12 20:57:40 by vgoncalv          #+#    #+#             --
--   Updated: 2021/12/26 19:31:23 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local M = {}

local bo = vim.bo

M.config = M.config or {}

-- Default configuration, filetypes cannot be overwritten
local default_config = {
	intra_login = 'marvin',
	intra_mail = 'marvin@42.fr',
	ft = {
		c = {
			start_comment = '/*',
			end_comment = '*/',
			fill_comment = '*',
		},
		cpp = {
			start_comment = '/*',
			end_comment = '*/',
			fill_comment = '*',
		},
		make = {
			start_comment = '##',
			end_comment = '##',
			fill_comment = '#',
		},
		python = {
			start_comment = '##',
			end_comment = '##',
			fill_comment = '#',
		},
		lua = {
			start_comment = '--',
			end_comment = '--',
			fill_comment = '-',
		},
		vim = {
			start_comment = '""',
			end_comment = '""',
			fill_comment = '*',
		},
	},
}

---@param opts table
function M.setup(opts)
	M.config = setmetatable(opts or {}, {
		__index = default_config,
	})
	return M.config
end

---@return string: intra login
function M.intra_login()
	return M.config.intra_login
end

---@return string: intra mail
function M.intra_mail()
	return M.config.intra_mail
end

---@return string: start comment
function M.start_comment()
	return M.config.ft[bo.filetype].start_comment
end

---@return string: fill comment
function M.fill_comment()
	return M.config.ft[bo.filetype].fill_comment
end

---@return string: end comment
function M.end_comment()
	return M.config.ft[bo.filetype].end_comment
end

return M
