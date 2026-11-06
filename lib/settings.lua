-- ============================================================
-- GOxv Settings
-- ============================================================

return function(U, T, config, UI)

    local settingsTab = UI.addTab("settings", "Settings")
    local scroll = UI.makeScroll(settingsTab)

    local function row(label, value)
        local r = Instance.new("Frame")
        r.BackgroundColor3 = T.Surface
        r.BorderSizePixel = 0
        r.Size = UDim2.new(1, 0, 0, 56)
        r.Parent = scroll
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = r

        local l = UI.makeLabel(r, label, 18, T.Text, true)
        l.Position = UDim2.new(0, 12, 0, 8)

        local v = UI.makeLabel(r, value, 14, T.Dim, false)
        v.Position = UDim2.new(0, 12, 0, 30)
    end

    row("API Key", (config.OpenRouterKey:sub(1, 10)) .. "…")
    row("Model", config.Model)
    row("Version", config.Version)
    row("Script", "GOxv · modular · GitHub-hosted")

    return {}
end
