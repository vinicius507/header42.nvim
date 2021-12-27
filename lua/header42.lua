-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header42.lua                                       :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: emendes- <emendes-@students.42sp.org.br>   +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/05/15 11:51:46 by emendes-          #+#    #+#             --
--   Updated: 2021/12/27 07:25:38 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local M = {}

local config = require('header42.config')
local header = require('header42.header')

M.setup = function(opts)
	config.setup(opts)
	vim.api.nvim_create_namespace('header42')
end

M.Stdheader = function()
	if header.is_present() then
		header.update()
	else
		header.insert()
	end
end

return M
