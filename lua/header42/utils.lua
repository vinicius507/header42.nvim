local utils = {}

local fn = vim.fn
local notify = vim.notify

---@param msg string
function utils.error(msg)
	notify(msg, 'error', { title = 'header42.nvim' })
end

---@return string: header42 format
function utils.load_format()
	local format = {}
	local filepaths = fn.glob(fn.stdpath('data') .. '**/header_format', 0, 1)

	if #filepaths == 0 then
		utils.error(
			"Could not find header_format. Make sure header42.nvim is installed in stdpath('data'"
		)
	end

	for line in io.lines(filepaths[1]) do
		format[#format + 1] = line
	end
	return format
end

return utils
