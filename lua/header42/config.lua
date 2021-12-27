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
	local config = vim.tbl_deep_extend('force', default_config, opts or {})
	M.config = setmetatable(config, {
		__index = default_config,
	})
end

---@return string: intra login
function M.intra_login()
	if M.config.ft[bo.filetype] ~= nil then
		return M.config.ft[bo.filetype].intra_login or M.config.intra_login
	end
	return M.config.intra_login
end

---@return string: intra mail
function M.intra_mail()
	if M.config.ft[bo.filetype] ~= nil then
		return M.config.ft[bo.filetype].intra_mail or M.config.intra_mail
	end
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
