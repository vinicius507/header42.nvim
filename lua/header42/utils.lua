local utils = {}

---@param msg string
function utils.error(msg)
	vim.notify(msg, 'error', { title = 'header42.nvim' })
end

---@param fmt string
---@param ... string
function utils.errorf(fmt, ...)
	vim.notify(string.format(fmt, ...), 'error', { title = 'header42.nvim' })
end

---@param section string: section to pad
---@param value string: value of section
---@return string
function utils.padding(section, value)
	if value:match('%[.*') then
		return '%s+'
	end
	local modifier = {
		filename_padding = 51,
		author_padding = 40,
		created_padding = 18,
		updated_padding = 17,
	}
	return string.rep(' ', modifier[section] - string.len(value))
end

return utils
