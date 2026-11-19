--- @module Foldtext
--- Foldtext com destaque Treesitter e fechamento visual com }

local function parse_line(linenr)
    local bufnr = vim.api.nvim_get_current_buf()

    local line = vim.api.nvim_buf_get_lines(bufnr, linenr - 1, linenr, false)[1]
    if not line then
        return nil
    end

    local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
    if not ok_parser or not parser then
        return nil
    end

    local ok_query, query = pcall(vim.treesitter.query.get, parser:lang(), "highlights")
    if not ok_query or not query then
        return nil
    end

    local trees = parser:parse({ linenr - 1, linenr })
    local tree = trees and trees[1]
    if not tree then
        return nil
    end

    local result = {}
    local line_pos = 0

    for id, node, metadata in query:iter_captures(tree:root(), bufnr, linenr - 1, linenr) do
        local name = query.captures[id]
        local start_row, start_col, end_row, end_col = node:range()
        local priority = tonumber(metadata.priority or vim.highlight.priorities.treesitter)

        if start_row == linenr - 1 and end_row == linenr - 1 then
            if start_col > line_pos then
                table.insert(result, {
                    line:sub(line_pos + 1, start_col),
                    { { "Folded", priority } },
                    range = { line_pos, start_col },
                })
            end

            line_pos = end_col

            table.insert(result, {
                line:sub(start_col + 1, end_col),
                { { "@" .. name, priority } },
                range = { start_col, end_col },
            })
        end
    end

    if line_pos < #line then
        table.insert(result, {
            line:sub(line_pos + 1),
            { { "Folded", vim.highlight.priorities.treesitter } },
            range = { line_pos, #line },
        })
    end

    local i = 1
    while i <= #result do
        local j = i + 1

        while j <= #result
            and result[j].range[1] >= result[i].range[1]
            and result[j].range[2] <= result[i].range[2]
        do
            for k, v in ipairs(result[i][2]) do
                if not vim.tbl_contains(result[j][2], v) then
                    table.insert(result[j][2], k, v)
                end
            end
            j = j + 1
        end

        if j > i + 1 then
            table.remove(result, i)
        else
            if #result[i][2] > 1 then
                table.sort(result[i][2], function(a, b)
                    return a[2] < b[2]
                end)
            end

            result[i][2] = vim.tbl_map(function(tbl)
                return tbl[1]
            end, result[i][2])

            result[i] = { result[i][1], result[i][2] }
            i = i + 1
        end
    end

    return result
end

function HighlightedFoldtext()
    local result = parse_line(vim.v.foldstart)

    if not result then
        return vim.fn.foldtext()
    end

    local line_count = vim.v.foldend - vim.v.foldstart

    -- Detecta linguagem
    local ft = vim.bo.filetype

    if ft == "python" then
        -- Python: não usa }
        table.insert(result, { " << +" .. line_count .. " lines >>", "FoldedText" })
    else
        -- C, C++, etc
        table.insert(result, { " << +" .. line_count .. " lines >>", "FoldedText" })
    end

    return result
end

local function set_fold_hl()
    local cl = vim.api.nvim_get_hl(0, { name = "CursorLineNr" })

    vim.api.nvim_set_hl(0, "FoldedIcon", {
        fg = cl.bg,
    })

    vim.api.nvim_set_hl(0, "FoldedText", {
        bg = cl.bg,
        fg = cl.fg,
        italic = true,
    })
end

set_fold_hl()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = set_fold_hl,
})

return 'luaeval("HighlightedFoldtext()")'
