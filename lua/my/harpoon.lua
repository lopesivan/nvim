local M = {}

local initialized = false

local function notify(msg, level)
    vim.notify(msg, level or vim.log.levels.INFO)
end

local function get_harpoon()
    local ok, harpoon = pcall(require, "harpoon")
    if not ok then
        notify("harpoon não está disponível", vim.log.levels.WARN)
        return nil
    end
    return harpoon
end

local function get_telescope_modules()
    local ok_finders, finders = pcall(require, "telescope.finders")
    local ok_pickers, pickers = pcall(require, "telescope.pickers")
    local ok_config, config = pcall(require, "telescope.config")
    local ok_state, state = pcall(require, "telescope.actions.state")

    if not (ok_finders and ok_pickers and ok_config and ok_state) then
        notify("telescope não está disponível", vim.log.levels.WARN)
        return nil
    end

    return {
        finders = finders,
        pickers = pickers,
        config = config,
        state = state,
    }
end

local function map(lhs, rhs, desc)
    vim.keymap.set("n", lhs, rhs, {
        desc = desc,
        silent = true,
    })
end

local function harpoon_items_to_paths(harpoon_files)
    local paths = {}

    for _, item in ipairs(harpoon_files.items or {}) do
        if item and item.value then
            table.insert(paths, item.value)
        end
    end

    return paths
end

local function remove_harpoon_item(harpoon_files, index)
    if not harpoon_files or not index then
        return
    end

    if harpoon_files.remove_at then
        harpoon_files:remove_at(index)
        return
    end

    table.remove(harpoon_files.items, index)
end

local function open_harpoon_telescope(harpoon)
    local telescope = get_telescope_modules()
    if not telescope then
        return
    end

    local harpoon_files = harpoon:list()

    local function make_finder()
        return telescope.finders.new_table({
            results = harpoon_items_to_paths(harpoon_files),
        })
    end

    telescope.pickers.new({}, {
        prompt_title = "Harpoon",
        finder = make_finder(),
        previewer = false,
        sorter = telescope.config.values.generic_sorter({}),
        layout_config = {
            height = 0.4,
            width = 0.5,
            prompt_position = "top",
            preview_cutoff = 120,
        },
        attach_mappings = function(prompt_bufnr, map_key)
            map_key("i", "<C-d>", function()
                local selected_entry = telescope.state.get_selected_entry()
                local current_picker = telescope.state.get_current_picker(prompt_bufnr)

                if not selected_entry or not selected_entry.index then
                    return
                end

                remove_harpoon_item(harpoon_files, selected_entry.index)
                current_picker:refresh(make_finder(), { reset_prompt = false })
            end)

            map_key("n", "<C-d>", function()
                local selected_entry = telescope.state.get_selected_entry()
                local current_picker = telescope.state.get_current_picker(prompt_bufnr)

                if not selected_entry or not selected_entry.index then
                    return
                end

                remove_harpoon_item(harpoon_files, selected_entry.index)
                current_picker:refresh(make_finder(), { reset_prompt = false })
            end)

            return true
        end,
    }):find()
end

function M.setup()
    local harpoon = get_harpoon()
    if not harpoon then
        return
    end

    harpoon:setup({
        settings = {
            save_on_toggle = false,
            sync_on_ui_close = false,
            save_on_change = true,
            enter_on_sendcmd = true,
            tmux_autoclose_windows = false,
            excluded_filetypes = {
                "harpoon",
                "alpha",
                "dashboard",
                "gitcommit",
            },
            mark_branch = false,
            key = function()
                return (vim.uv or vim.loop).cwd()
            end,
        },
    })

    if initialized then
        return
    end
    initialized = true

    for i = 1, 4 do
        map("<space>h" .. i, function()
            harpoon:list():select(i)
        end, string.format("Go to file %d", i))
    end

    map("<space>ht", function()
        open_harpoon_telescope(harpoon)
    end, "Telescope")

    map("<space>ha", function()
        harpoon:list():add()
    end, "Add file")

    map("<space>hm", function()
        if harpoon.ui and harpoon.ui.toggle_quick_menu then
            harpoon.ui:toggle_quick_menu(harpoon:list())
        else
            notify("UI do harpoon não está disponível", vim.log.levels.WARN)
        end
    end, "Quick menu")

    map("<space>hn", function()
        harpoon:list():next()
    end, "Next")

    map("<space>hp", function()
        harpoon:list():prev()
    end, "Previous")
end

return M
