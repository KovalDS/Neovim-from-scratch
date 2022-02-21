local status_ok, git_branch = pcall(require, "lualine.components.branch.git_branch")
if not status_ok then
    vim.cmd("echo 'Cant proceed without lua line'")
	return
end

local status_ok, autosave = pcall(require, "autosave")
if not status_ok then
    -- echo "Autosave is not installed"
	return
end

autosave.setup(
    {
        enabled = false,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)

function is_versioned()
    local branch = git_branch.find_git_dir()
    return not (branch == nil or branch =='');
end

function toggle_autosave()
    if (is_versioned()) then
        vim.cmd(":ASOn")
    else
        vim.cmd(":ASOff")
    end
end

vim.cmd[[
    augroup _autosave
        autocmd!
        autocmd DirChanged * lua toggle_autosave()
    augroup end
]]
