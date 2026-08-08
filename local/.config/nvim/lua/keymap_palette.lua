-- lua/keymap_palette_fzf.lua
local M = {}

-- which modes to include
local wanted_modes = { n = true, v = true, x = true, s = true, o = true }
local include_insert, include_terminal, include_cmdline = false, false, false
local require_desc = false -- set true to only list maps with a description

local mode_names = { n="n", v="v", x="x", s="s", o="o", i="i", t="t", c="c" }

local function has_keymap_get()
    return type(vim.keymap) == "table" and type(vim.keymap.get) == "function"
end

local function list_maps(mode, opts)
    if has_keymap_get() then
        return vim.keymap.get(mode, opts or {}) or {}
    end
    if opts and opts.buffer then
        return vim.api.nvim_buf_get_keymap(0, mode) or {}
    end
    return vim.api.nvim_get_keymap(mode) or {}
end

local function want(mode)
    if wanted_modes[mode] then return true end
    if mode == "i" then return include_insert end
    if mode == "t" then return include_terminal end
    if mode == "c" then return include_cmdline end
    return false
end

local function best_desc(m)
    local d = m.desc or m.description
    if d and d ~= "" then return d end
    if type(m.rhs) == "string" and m.rhs ~= "" then
        return (m.rhs:gsub("%s+", " "))
    end
    if m.callback then
        local ok, info = pcall(debug.getinfo, m.callback, "Sln")
        if ok and info and info.short_src then
            local name = info.name or "callback"
            return ("lua %s @ %s:%d"):format(name, info.short_src, info.linedefined or 0)
        end
        return "lua callback"
    end
    return nil
end

local function with_leaders(lhs)
    local out = lhs or ""
    if vim.g.mapleader and vim.g.mapleader ~= "" then
        local L = vim.g.mapleader:gsub("%%","%%%%")
        out = out:gsub("^" .. L, "<leader>")
    end
    if vim.g.maplocalleader and vim.g.maplocalleader ~= "" then
        local LL = vim.g.maplocalleader:gsub("%%","%%%%")
        out = out:gsub("^" .. LL, "<localleader>")
    end
    return out
end

local function disp_pad_right(s, width)
    local w = vim.fn.strdisplaywidth(s)
    if w >= width then return s end
    return s .. string.rep(" ", width - w)
end

local function gather_items()
    local items = {}
    for _, mode in ipairs({ "n","v","x","s","o","i","t","c" }) do
        if want(mode) then
            for _, m in ipairs(list_maps(mode, {})) do
                local desc = best_desc(m)
                if not require_desc or desc then
                    table.insert(items, { mode=mode, lhs=m.lhs, desc=desc or "", buf=nil })
                end
            end
            for _, m in ipairs(list_maps(mode, { buffer = 0 })) do
                local desc = best_desc(m)
                if not require_desc or desc then
                    table.insert(items, { mode=mode, lhs=m.lhs, desc=desc or "", buf=0 })
                end
            end
        end
    end

    -- de-dup prefer buffer-local
    local seen, out = {}, {}
    for _, it in ipairs(items) do
        if it.lhs and it.lhs ~= "" then
            local k = table.concat({ it.mode or "", it.lhs, it.desc or "" }, "\1")
            if not seen[k] or (seen[k].buf == nil and it.buf == 0) then
                seen[k] = it
            end
        end
    end
    for _, it in pairs(seen) do table.insert(out, it) end

    table.sort(out, function(a,b)
        if a.mode == b.mode then return a.lhs < b.lhs end
        return (a.mode or "") < (b.mode or "")
    end)

    return out
end

function M.open()
  local items = gather_items()
  if #items == 0 then
    vim.notify("No keymaps found" .. (require_desc and " (require_desc=true)" or ""), vim.log.levels.INFO)
    return
  end

  local lines, index = {}, {}
  local mode_w, lhs_w = 1, 22 -- tune widths to taste

  for i, it in ipairs(items) do
    local mode_col = mode_names[it.mode] or it.mode
    local lhs_col  = with_leaders(it.lhs or "")
    local desc_col = (it.desc ~= "" and it.desc) or "—"
    if it.buf == 0 then desc_col = desc_col .. "  [buf]" end

    local col1 = disp_pad_right(mode_col, mode_w)
    local col2 = disp_pad_right(lhs_col,  lhs_w)

    local shown = col1 .. "  " .. col2 .. "  " .. desc_col
    -- Put SHOWN text in field #1, numeric id in field #2 (hidden)
    lines[i] = shown .. "\t" .. tostring(i)
    index[i] = it
  end

  require("fzf-lua").fzf_exec(lines, {
    prompt = "Keymap> ",
    fzf_opts = {
      ["--delimiter"] = "\t", -- fields split by TAB
      ["--with-nth"]  = "1",  -- show only field #1
      ["--nth"]       = "1",  -- search only field #1
      ["--no-multi"]  = "",
    },
    actions = {
      ["default"] = function(selected)
        local line = selected[1] or ""
        local id = tonumber(line:match("\t(%d+)$"))
        local it = id and index[id] or nil
        if not it or not it.lhs or it.lhs == "" then return end

        local keys = vim.api.nvim_replace_termcodes(it.lhs, true, true, true)
        if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
        if it.mode == "v" or it.mode == "x" or it.mode == "s" then
          pcall(vim.cmd.normal, { "gv", bang = true })
        end
        vim.api.nvim_input(keys)
      end,
    },
  })
end

return M

