-- my_motion.lua
-- $Id$
-- Name Of File: my_motion.lua
--
--  Description: Neovim plugin (Lua) — convertido de my_motion.vim
--
--       Author: Ivan Lopes <lopesivan (at) poli (dot) com (dot) br>
--   Maintainer: Ivan Lopes <lopesivan (at) poli (dot) com (dot) br>
--
--    Copyright: This script is released under the Vim License.

if vim.o.compatible or vim.g.loaded_motion then
  return
end
vim.g.loaded_motion = "v01"

local M = {}

-- Definido mais abaixo (perto dos mapeamentos); forward-declarada aqui
-- porque diagnose_keymodel() precisa dela e é definida antes na ordem
-- textual do arquivo.
local owner_of

--------------------------------------------------------------------------------

local function echo(msg, hl)
  vim.api.nvim_echo({ { msg, hl } }, false, {})
end

-- Move o bloco [top, bottom] (1 linha ou várias, em qualquer ordem) para
-- cima. Usa números de linha explícitos em vez de marks '<,'> porque essas
-- marks só são atualizadas quando se entra no cmdline vindo do Visual
-- (o ':' do vimscript original fazia isso implicitamente); um mapeamento
-- Lua direto não passa por ali, então ficavam com a seleção anterior.
local function MoveBlockUp(top, bottom)
  local count1 = vim.v.count1
  if top - count1 - 1 < 0 then
    echo("-- First line --", "WarningMsg")
    return nil, nil
  end
  local col_num = vim.fn.virtcol(".")
  vim.cmd(
    string.format("silent! %d,%dmove %d", top, bottom, top - count1 - 1)
  )
  vim.cmd("normal! " .. col_num .. "|")
  echo("-- Move to up --", "NonText")
  -- Depois do :move, top/bottom deslocam exatamente count1 linhas pra
  -- cima - não precisamos (nem devemos) reler '< '>.
  return top - count1, bottom - count1
end

local function MoveBlockDown(top, bottom)
  local count1 = vim.v.count1
  if bottom + count1 > vim.fn.line("$") then
    echo("-- Last line --", "WarningMsg")
    return nil, nil
  end
  local col_num = vim.fn.virtcol(".")
  vim.cmd(string.format("silent! %d,%dmove %d", top, bottom, bottom + count1))
  vim.cmd("normal! " .. col_num .. "|")
  echo("-- Move to down --", "NonText")
  return top + count1, bottom + count1
end

-- Limites da seleção visual atual: '< e '> só ficam corretos (congelados
-- na seleção que o usuário acabou de fazer) se a função for chamada a
-- partir do cmdline vindo do Visual (":<C-u>lua ...<CR>") — é exatamente
-- o que o vimscript original fazia com ":<C-u>call ...<CR>". Um callback
-- Lua "puro" ligado direto na tecla não garante isso, por isso o
-- mapeamento abaixo usa uma string de comando, não uma function.
local function visual_bounds()
  local a, b = vim.fn.line("'<"), vim.fn.line("'>")
  if a > b then
    a, b = b, a
  end
  return a, b
end

function M.MoveLineUp()
  local l = vim.fn.line(".")
  MoveBlockUp(l, l)
end

function M.MoveLineDown()
  local l = vim.fn.line(".")
  MoveBlockDown(l, l)
end

-- Reseleciona um bloco linewise por número de linha, sem depender de
-- '< '> (que ficam indefinidas/erradas depois de um :move).
local function reselect_visual(top, bottom)
  vim.fn.cursor(top, 1)
  vim.cmd("normal! V")
  vim.fn.cursor(bottom, 1)
end

function M.MoveVisualUp()
  local top, bottom = visual_bounds()
  local new_top, new_bottom = MoveBlockUp(top, bottom)
  if new_top then
    reselect_visual(new_top, new_bottom)
  else
    reselect_visual(top, bottom)
  end
end

function M.MoveVisualDown()
  local top, bottom = visual_bounds()
  local new_top, new_bottom = MoveBlockDown(top, bottom)
  if new_top then
    reselect_visual(new_top, new_bottom)
  else
    reselect_visual(top, bottom)
  end
end

-- Desloca o bloco selecionado (linhas) para a direita/esquerda em
-- 'shiftwidth', repetível pelo count1, mantendo a seleção.
function M.MoveVisualRight()
  local top, bottom = visual_bounds()
  local count1 = vim.v.count1
  for _ = 1, count1 do
    vim.cmd(string.format("silent! %d,%d>", top, bottom))
  end
  echo("-- Shift right --", "NonText")
  reselect_visual(top, bottom)
end

function M.MoveVisualLeft()
  local top, bottom = visual_bounds()
  local count1 = vim.v.count1
  for _ = 1, count1 do
    vim.cmd(string.format("silent! %d,%d<", top, bottom))
  end
  echo("-- Shift left --", "NonText")
  reselect_visual(top, bottom)
end

-- Diagnóstico extra: confirma se o terminal manda <S-Up> distinguível de
-- <Up>, e se 'keymodel' tem stopsel (que faz seta sem Shift encerrar o
-- Visual sozinha). Rode :lua require('config.my_motion').diagnose_keymodel()
function M.diagnose_keymodel()
  print("keymodel = '" .. vim.o.keymodel .. "'")
  print("selectmode = '" .. vim.o.selectmode .. "'")
  print(
    "<S-Up> mapeado em v? -> " .. tostring(owner_of("<S-Up>", "v") ~= nil)
  )
  print("<Up> mapeado em v?   -> " .. tostring(owner_of("<Up>", "v") ~= nil))
end

--------------------------------------------------------------------------------

function M.MoveCharToRight()
  local cursor_position_x = vim.fn.col(".")
  local last_cursor_position = vim.fn.col("$") - 1

  if cursor_position_x == last_cursor_position then
    echo("-- End of line --", "WarningMsg")
  else
    vim.cmd("normal xp")
    echo("-- Move to right --", "NonText")
  end
end

function M.MoveCharToLeft()
  local cursor_position_x = vim.fn.col(".")

  if cursor_position_x == 1 then
    echo("-- Begin of line --", "WarningMsg")
  else
    vim.cmd("normal xhP")
    echo("-- Move to left --", "NonText")
  end
end

function M.MoveCharToRightV()
  local cursor_position_x = vim.fn.col(".")
  local last_cursor_position = vim.fn.col("$") - 1

  if cursor_position_x == last_cursor_position then
    echo("-- End of line --", "WarningMsg")
  else
    vim.cmd("normal xpgvlolo")
    echo("-- Move to right --", "NonText")
  end
end

function M.MoveCharToLeftV()
  local cursor_position_x = vim.fn.col(".")

  if cursor_position_x == 1 then
    echo("-- Begin of line --", "WarningMsg")
  else
    vim.cmd("normal xhPgvhoho")
    echo("-- Move to left --", "NonText")
  end
end

--------------------------------------------------------------------------------
-- No original .vim, "scrollaction" já era uma string vazia (sem ação real).
-- Mantido fiel ao comportamento original (só valida limite e redesenha).

function M.MoveScreenToUP()
  local first_line_visible = vim.fn.line("w0") + 3
  local current_line = vim.fn.line(".")

  if first_line_visible == current_line then
    echo("-- Begin of Screen --", "WarningMsg")
  else
    vim.cmd("redraw")
    echo("-- Move to UP --", "NonText")
  end
end

function M.MoveScreenToDown()
  local last_line_visible = vim.fn.line("w$") - 3
  local current_line = vim.fn.line(".")

  if last_line_visible == current_line then
    echo("-- End of Screen --", "WarningMsg")
  else
    vim.cmd("redraw")
    echo("-- Move to Down --", "NonText")
  end
end

--------------------------------------------------------------------------------

local function listed_buffers_count()
  local count = 0
  for buf = 1, vim.fn.bufnr("$") do
    if vim.fn.buflisted(buf) == 1 then
      count = count + 1
    end
  end
  return count
end

local function in_tmux()
  return vim.fn.exists("$TMUX") == 1
end

function M.Wnext()
  if vim.fn.tabpagenr("$") == 1 then
    if listed_buffers_count() == 1 then
      if in_tmux() then
        vim.fn.system("tmux next-window")
      end
    else
      vim.cmd("bnext")
    end
  else
    vim.cmd("tabnext")
  end
end

function M.WNext()
  if vim.fn.tabpagenr("$") == 1 then
    if listed_buffers_count() == 1 then
      if in_tmux() then
        vim.fn.system("tmux previous-window")
      end
    else
      vim.cmd("bNext")
    end
  else
    vim.cmd("tabNext")
  end
end

function M.WFirst()
  if vim.fn.tabpagenr("$") == 1 then
    if listed_buffers_count() == 1 then
      if in_tmux() then
        vim.fn.system("tmux copy-mode")
      end
    else
      vim.cmd("bf")
    end
  else
    vim.cmd("tabfirst")
  end
end

function M.WLast()
  if vim.fn.tabpagenr("$") == 1 then
    if listed_buffers_count() == 1 then
      if in_tmux() then
        vim.fn.system("tmux new-window")
      end
    else
      vim.cmd("bl")
    end
  else
    vim.cmd("tablast")
  end
end

--------------------------------------------------------------------------------
-- Mapeamentos: cada combinação tecla+modo é checada e instalada
-- independentemente. Se <C-Right> já estiver ocupado (comum com
-- tmux-navigator, por exemplo), isso NÃO impede que <S-Up>/<S-Down> no
-- Visual sejam instalados — antes, um conflito em qualquer uma das 8
-- teclas cancelava tudo, e era exatamente isso que fazia o Shift+Up no
-- Visual cair no comportamento padrão (estende seleção e sai do Visual).

-- Retorna nil se {lhs,mode} estiver livre, ou uma string descrevendo o
-- dono do mapeamento conflitante (arquivo/linha via sid).
owner_of = function(lhs, mode)
  local info = vim.fn.maparg(lhs, mode, false, true)
  if not info or not info.lhs or info.lhs == "" then
    return nil
  end
  local where = "?"
  if info.sid and info.sid > 0 then
    local scripts = vim.fn.getscriptinfo({ sid = info.sid })
    if scripts and scripts[1] then
      where = scripts[1].name .. (info.lnum and (":" .. info.lnum) or "")
    end
  end
  return string.format(
    "modo=%s lhs=%s rhs=%s origem=%s",
    mode,
    lhs,
    (info.rhs ~= "" and info.rhs or "<callback lua>"),
    where
  )
end

local mappings = {
  { lhs = "<S-Right>", mode = "n", rhs = M.MoveCharToRight },
  { lhs = "<S-Right>", mode = "i", rhs = M.MoveCharToRight },
  { lhs = "<S-Left>", mode = "n", rhs = M.MoveCharToLeft },
  { lhs = "<S-Left>", mode = "i", rhs = M.MoveCharToLeft },

  { lhs = "<C-Right>", mode = "n", rhs = M.Wnext },
  { lhs = "<C-Left>", mode = "n", rhs = M.WNext },
  { lhs = "<C-Up>", mode = "n", rhs = M.WFirst },
  { lhs = "<C-Down>", mode = "n", rhs = M.WLast },

  { lhs = "<S-Up>", mode = "n", rhs = M.MoveLineUp },
  { lhs = "<S-Down>", mode = "n", rhs = M.MoveLineDown },
  { lhs = "<S-Up>", mode = "i", rhs = M.MoveLineUp },
  { lhs = "<S-Down>", mode = "i", rhs = M.MoveLineDown },
  {
    lhs = "<S-Up>",
    mode = "v",
    rhs = ":<C-u>lua require('my.my_motion').MoveVisualUp()<CR>",
  },
  {
    lhs = "<S-Down>",
    mode = "v",
    rhs = ":<C-u>lua require('my.my_motion').MoveVisualDown()<CR>",
  },
  {
    lhs = "<S-Right>",
    mode = "v",
    rhs = ":<C-u>lua require('my.my_motion').MoveVisualRight()<CR>",
  },
  {
    lhs = "<S-Left>",
    mode = "v",
    rhs = ":<C-u>lua require('my.my_motion').MoveVisualLeft()<CR>",
  },
}

-- Chame :lua require('my.my_motion').diagnose() a qualquer momento pra ver
-- o estado atual sem precisar reabrir o nvim.
function M.diagnose()
  local any = false
  for _, m in ipairs(mappings) do
    local desc = owner_of(m.lhs, m.mode)
    if desc then
      any = true
      print("[my_motion] OCUPADO -> " .. desc)
    end
  end
  if not any then
    print("[my_motion] nenhuma das teclas está mapeada por outro plugin.")
  end
end

for _, m in ipairs(mappings) do
  local desc = owner_of(m.lhs, m.mode)
  if desc then
    vim.notify(
      "[my_motion] pulando "
        .. m.lhs
        .. " ("
        .. m.mode
        .. ") - ja mapeada: "
        .. desc,
      vim.log.levels.WARN
    )
  else
    vim.keymap.set(m.mode, m.lhs, m.rhs, { silent = true })
  end
end

-- Pares para trocar palavra à esquerda/direita (comentados no original):
-- vim.keymap.set('n', '`h', ...)
-- vim.keymap.set('n', '`l', ...)

return M
