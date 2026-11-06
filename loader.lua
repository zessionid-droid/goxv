-- ============================================================
-- GOxv Loader
-- Paste ini ke Delta Executor. Semua module di-fetch dari GitHub.
-- ============================================================

local GITHUB_BASE = "https://raw.githubusercontent.com/zessionid-droid/goxv/main/"

local function fetch(path)
    local ok, res = pcall(function()
        return game:HttpGet(GITHUB_BASE .. path)
    end)
    if not ok or not res or #res < 10 then
        error("[GOxv] Gagal fetch: " .. path .. " — " .. tostring(res))
    end
    return res
end

print("[GOxv] loading modules…")

local config   = loadstring(fetch("config.lua"))()
local utils    = loadstring(fetch("lib/utils.lua"))()
local theme    = loadstring(fetch("lib/theme.lua"))()

-- UI butuh utils + theme + config
local ui       = loadstring(fetch("lib/ui.lua"))(utils, theme, config)
local chat     = loadstring(fetch("lib/chat.lua"))(utils, theme, config, ui)
local assets   = loadstring(fetch("lib/assets.lua"))(utils, theme, config, ui)
local settings = loadstring(fetch("lib/settings.lua"))(utils, theme, config, ui)

-- main menyambungkan semuanya
loadstring(fetch("main.lua"))(utils, theme, config, ui, chat, assets, settings)

print("[GOxv] loaded")
