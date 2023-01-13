local M = {}

local log = require("header42.log")
local ftheader = require("header42.header")

function M.insert()
	local config = require("header42.config")

	local author = string.format("%s <%s>", config.login, config.email)
	local filename = vim.fn.expand("%:t")
	local insertion_date = vim.fn.strftime("%Y/%m/%d %H:%M:%S")

	local ft = vim.api.nvim_buf_get_option(0, "filetype")
	local delimeters = require("header42.delimeters")[ft]

	if delimeters == nil then
		log.error("Unsupported filetype: %s", ft)
		return
	end

	local header = ftheader.new({
		filename = filename,
		author = author,
		created_at = insertion_date,
		created_by = config.login,
		updated_at = insertion_date,
		updated_by = config.login,
		delimeters = delimeters,
	})

	-- Neodev thinks that the second parameter to append can only be a string
	vim.fn.append(0, header) ---@diagnostic disable-line
end

return M
