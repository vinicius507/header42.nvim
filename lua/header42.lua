-- -------------------------------------------------------------------------- --
--                                                                            --
--                                                        :::      ::::::::   --
--   header42.lua                                       :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: emendes- <emendes-@students.42sp.org.br>   +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/05/15 11:51:46 by emendes-          #+#    #+#             --
--   Updated: 2021/12/26 19:34:34 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- -------------------------------------------------------------------------- --

local M = {}

local config = require('header42.config')

M.setup = function(opts)
	config.setup(opts)
end

return M
