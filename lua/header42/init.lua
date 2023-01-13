-- ************************************************************************** --
--                                                                            --
--                                                        :::      ::::::::   --
--   init.lua                                           :+:      :+:    :+:   --
--                                                    +:+ +:+         +:+     --
--   By: vgoncalv <vgoncalv@student.42sp.org.br>    +#+  +:+       +#+        --
--                                                +#+#+#+#+#+   +#+           --
--   Created: 2021/05/15 11:51:46 by emendes-          #+#    #+#             --
--   Updated: 2023/01/13 10:12:45 by vgoncalv         ###   ########.fr       --
--                                                                            --
-- ************************************************************************** --

local M = {}

---@type fun(opts: FtHeaderConfig?)
function M.setup(opts)
	require("header42.config").setup(opts)
end

return M
