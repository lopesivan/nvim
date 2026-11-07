local M = {}

----------------------------------------------------
-- Mostra o caractere (ASCII ou UTF-8), e seus bytes
----------------------------------------------------
-- v1
-- local function fmt_char_info(ch)
--     -- codepoint Unicode (em decimal e U+XXXX)
--     local cp = vim.fn.char2nr(ch, true) or 0

--     -- bytes UTF-8 do caractere
--     local hex = {}
--     for i = 1, #ch do
--         hex[#hex + 1] = string.format("%02X", ch:byte(i))
--     end

--     return string.format("%s  bytes:0x%s  cp:%d (U+%04X)",
--         ch,
--         table.concat(hex),
--         cp, cp
--     )
-- end

-- local function cursor_utf()
--     local line = vim.api.nvim_get_current_line()
--     local col  = vim.fn.col('.') -- índice 1-based em bytes

--     if col == 0 or col > #line then
--         return ''
--     end

--     -- Volta até o início do codepoint
--     local back = vim.str_utf_start(line, col) -- p.ex. 0 (início), -1, -2...
--     local start = col + back                  -- byte inicial do codepoint

--     -- Quanto falta até o último byte do codepoint
--     local to_end = vim.str_utf_end(line, start) -- p.ex. 0 (1 byte), 1, 2, 3...
--     local stop = start + to_end                 -- byte final do codepoint

--     -- Recorta o codepoint completo (todos os bytes)
--     local ch = line:sub(start, stop)

--     -- Se quiser “ASCII vs não-ASCII”
--     local is_ascii = #ch == 1 and ch:byte() < 0x80

--     -- Bytes em hex para depurar
--     local hex = {}
--     for i = 1, #ch do
--         hex[#hex + 1] = string.format("%02X", ch:byte(i))
--     end

--     -- Cuidado: emoji pode ser largura dupla no statusline
--     -- Use 13 colunas como você já fazia para “fixar” layout
--     return string.format(" %-2s 0x%s:%03d",
--         ch,                           -- caractere visível (agora completo)
--         table.concat(hex),            -- bytes hex (sem espaço, ajuste se quiser)
--         vim.fn.char2nr(ch, true) or 0 -- codepoint (true => retorna unicode)
--     )
-- end

-- v2
-- local function fmt_char_info(ch)
--     local cp = vim.fn.char2nr(ch, true) or 0
--     local hex = {}
--     for i = 1, #ch do
--         hex[#hex + 1] = string.format("%02X", ch:byte(i))
--     end
--     return string.format("%s  bytes:0x%s  cp:%d (U+%04X)",
--         ch, table.concat(hex), cp, cp)
-- end

-- local function cursor_utf()
--     local line = vim.api.nvim_get_current_line()
--     local col  = vim.fn.col('.') -- 1-based, em bytes
--     if col == 0 or col > #line then return '' end

--     local start = col + vim.str_utf_start(line, col)
--     local stop  = start + vim.str_utf_end(line, start)
--     local ch    = line:sub(start, stop)

--     -- statusline estável (13 colunas como você usa)
--     return string.format(" %-13s", fmt_char_info(ch))
-- end

-- v3
----------------------------------------------------
--  Mostra ASCII com info fixa; senão, placeholder
--  Formato (13 colunas): " %-2s 0x%02X:%03d"
--  Placeholder:          " #  0x--:---"
----------------------------------------------------
-- local function cursor_ascii_fixed()
--     local line = vim.api.nvim_get_current_line()
--     local col  = vim.fn.col('.') -- índice 1-based em bytes

--     if col == 0 or col > #line then
--         return ''
--     end

--     -- Alinha no início do codepoint e pega-o inteiro
--     local start = col + vim.str_utf_start(line, col)
--     local stop  = start + vim.str_utf_end(line, start)
--     local ch    = line:sub(start, stop)

--     -- ASCII imprimível = 1 byte e dentro de 0x20..0x7E
--     if #ch == 1 then
--         local b = ch:byte()
--         if b >= 0x20 and b <= 0x7E then
--             local shown = ch
--             -- Escapa % para o statusline (não para string.format)
--             if shown == '%' then shown = '%%' end
--             return string.format(' %-2s 0x%02X:%03d', shown, b, b)
--         end
--     end

--     -- Placeholder (mesma largura do formato acima)
--     return ' #  0x--:---'
-- end

----------------------------------------------------
--  Função que mostra o ASCII OU '#'
----------------------------------------------------
-- local function cursor_ascii()
--     local line = vim.api.nvim_get_current_line()
--     local col  = vim.fn.col('.') -- índice de byte (1-based)

--     if col == 0 or col > #line then
--         return ''
--     end

--     local byte = line:byte(col)

--     -- não-ASCII → string “placeholder”, 13 colunas
--     if not byte or byte > 0xFF then
--         return ' #  0x--:---'
--     end

--     local char = vim.fn.nr2char(byte)
--     if char == '%' then
--         char = '%% '
--     end

--     -- char ASCII válido, também 13 colunas
--     -- %-2s garante 2 posições; %02X → 2 dígitos; %03d → 3 dígitos
--     return string.format(' %-2s 0x%02X:%03d',
--         char, -- char visível
--         byte, -- hex
--         byte) -- dec
-- end

-- v4
-- Largura fixa do campo (só o conteúdo, sem o ícone)
local FIELD_W = 20
local PLACEHOLDER = "-----:-----"

-- Escapa % para não confundir o statusline
local function escape_statusline(s)
  return s:gsub("%%", "%%%%")
end

-- Ajusta a string para caber exatamente em FIELD_W colunas de display.
-- Não corta bytes no meio e respeita largura de emoji/kanji etc.
local function fit_display(s, width)
  if not s or s == "" then
    s = PLACEHOLDER
  end

  local out, w = {}, 0
  local pos = vim.str_utf_pos(s) -- inícios de cada codepoint (em bytes)
  for i, start in ipairs(pos) do
    local stop = (pos[i + 1] or (#s + 1)) - 1
    local ch = s:sub(start, stop)
    local cw = vim.fn.strdisplaywidth(ch)

    -- Evita começar com mark de largura 0 sem base
    if not (w == 0 and cw == 0) then
      -- Se passar do limite e o char tem largura > 0, para.
      if cw > 0 and (w + cw) > width then
        break
      end
      table.insert(out, ch)
      w = w + cw
      -- Ainda permite anexar marks de largura 0 após atingir o limite.
      if w >= width then
        -- consome marks seguintes (cw == 0) sem aumentar largura
        for j = i + 1, #pos do
          local s2 = pos[j]
          local e2 = (pos[j + 1] or (#s + 1)) - 1
          local ch2 = s:sub(s2, e2)
          if vim.fn.strdisplaywidth(ch2) == 0 then
            table.insert(out, ch2)
          else
            break
          end
        end
        break
      end
    end
  end

  local res = table.concat(out)
  local pad = width - vim.fn.strdisplaywidth(res)
  if pad > 0 then
    res = res .. string.rep(" ", pad)
  end
  return res
end

local function fmt_char_info(ch)
  if not ch or ch == "" then
    return PLACEHOLDER
  end
  local cp = vim.fn.char2nr(ch, true) or 0
  local hex = {}
  for i = 1, #ch do
    hex[#hex + 1] = string.format("%02X", ch:byte(i))
  end
  return string.format("%s 0x%s:%d (U+%04X)", ch, table.concat(hex), cp, cp)
end

local function cursor_utf()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col(".") -- 1-based, em bytes

  -- Fora dos limites → placeholder
  if col == 0 or col > #line then
    local info = fit_display(PLACEHOLDER, FIELD_W)
    return " " .. escape_statusline(info)
  end

  -- Pega o codepoint completo sob o cursor
  local start = col + vim.str_utf_start(line, col)
  local stop = start + vim.str_utf_end(line, start)
  local ch = line:sub(start, stop)

  -- Monta info e ajusta para largura fixa
  local info = fmt_char_info(ch)
  info = fit_display(info, FIELD_W)

  return " " .. escape_statusline(info)
end

----------------------------------------------------
-- 1. Função que mostra quando estamos gravando
----------------------------------------------------
local function macro_recording()
  local reg = vim.fn.reg_recording()
  if reg == "" then
    return ""
  end
  return "📷[" .. reg .. "]"
end

local lualine = require("lualine")

-- Color table for highlights
-- stylua: ignore
local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
}

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

-- Config
local config = {
  options = {
    -- Disable sections and component separators
    component_separators = "",
    section_separators = "",
    theme = {
      normal = { c = { fg = colors.fg, bg = colors.bg } },
      inactive = { c = { fg = colors.fg, bg = colors.bg } },
      command = {
        a = { fg = colors.bg, bg = colors.magenta }, -- Magenta destaca o modo de comando
        b = { fg = colors.fg, bg = colors.darkblue },
        c = { fg = colors.fg, bg = colors.bg },
      },
    },
  },
  sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    -- These will be filled later
    lualine_c = {},
    lualine_x = { "overseer" },
  },
  inactive_sections = {
    -- these are to remove the defaults
    lualine_a = {},
    lualine_b = {},
    lualine_y = {},
    lualine_z = {},
    lualine_c = {},
    lualine_x = {},
  },
}

-- Inserts a component in lualine_c at left section
local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end

-- Inserts a component in lualine_x at right section
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({
  function()
    return "▊"
  end,
  color = { fg = colors.blue }, -- Sets highlighting of component
  padding = { left = 0, right = 1 }, -- We don't need space before this
})

ins_left({ macro_recording })

ins_left({
  -- mode component
  function()
    return ""
  end,
  color = function()
    -- auto change color according to neovims mode
    local mode_color = {
      n = colors.red,
      i = colors.green,
      v = colors.blue,
      [""] = colors.blue,
      V = colors.blue,
      c = colors.magenta,
      no = colors.red,
      s = colors.orange,
      S = colors.orange,
      [""] = colors.orange,
      ic = colors.yellow,
      R = colors.violet,
      Rv = colors.violet,
      cv = colors.red,
      ce = colors.red,
      r = colors.cyan,
      rm = colors.cyan,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.red,
    }
    return { fg = mode_color[vim.fn.mode()] }
  end,
  padding = { right = 1 },
})

ins_left({
  -- filesize component
  -- "filesize",
  "selectioncount",
  -- "searchcount",
  cond = conditions.buffer_not_empty,
})

ins_left({ "location" })

ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

ins_left({
  cursor_utf, -- ⬅ aqui vai a função
  -- cursor_ascii,
  -- cursor_ascii_fixed,
  cond = conditions.hide_in_width, -- só aparece se a janela ≥81 colunas
  color = { fg = colors.yellow, gui = "bold" },
})

ins_left({
  "diagnostics",
  sources = { "nvim_diagnostic" },
  symbols = { error = "E ", warn = "W ", info = "I ", hint = "H " },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn = { fg = colors.yellow },
    color_info = { fg = colors.cyan },
  },
})

-- Insert mid section. You can make any number of sections in neovim :)
-- for lualine it's any number greater then 2
ins_left({
  function()
    return "%="
  end,
})

ins_left({
  -- Lsp server name corrigido para Neovim 0.10+
  function()
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
      return "No Active Lsp"
    end

    local client_names = {}
    for _, client in ipairs(buf_clients) do
      -- Evita colocar formatadores como copilot, null-ls ou efm se você quiser apenas o LSP puro,
      -- mas por padrão listamos todos os anexados ao buffer atual:
      table.insert(client_names, client.name)
    end

    return table.concat(client_names, ", ")
  end,
  icon = " LSP:",
  color = { fg = colors.green, gui = "bold" }, -- Mudei para verde para destacar melhor no seu tema escuro, se preferir volte para "#ffffff"
})

-- {{{ Add components to right sections

ins_right({
  function()
    local harpoon = require("harpoon")
    local list = harpoon:list()
    -- local n_list = #list.items
    local n_list = list:length() or 0
    local status = "Ø"

    if n_list > 0 then
      status = n_list
    end
    return string.format("H:%s", status)
  end,
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.blue, gui = "bold" },
})

ins_right({
  "o:encoding", -- option component same as &encoding in viml
  fmt = string.upper, -- I'm not sure why it's upper case either ;)
  cond = conditions.hide_in_width,
  color = { fg = colors.green, gui = "bold" },
})

ins_right({
  "branch",
  icon = "",
  color = { fg = colors.violet, gui = "bold" },
})

ins_right({
  "diff",
  -- Is it me or the symbol for modified us really weird
  symbols = { added = " ", modified = "M ", removed = " " },
  diff_color = {
    added = { fg = colors.green },
    modified = { fg = colors.orange },
    removed = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
})

-- ins_right {
--     function()
--         return "▊"
--     end,
--     color = { fg = colors.blue },
--     padding = { left = 1 },
-- }

-- ------------------------------------------------------------------------ }}}
function M.setup()
  lualine.setup(config)
end

-- Now don't forget to initialize lualine

return M
