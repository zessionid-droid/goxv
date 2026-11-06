-- ============================================================
-- GOxv Asset Browser
-- ============================================================

return function(U, T, config, UI)

    local assetTab = UI.addTab("asset", "Assets")

    -- search bar
    local searchArea = Instance.new("Frame")
    searchArea.BackgroundColor3 = T.Surface
    searchArea.BorderSizePixel = 0
    searchArea.Size = UDim2.new(1, 0, 0, 44)
    searchArea.Parent = assetTab

    local sac = Instance.new("UICorner")
    sac.CornerRadius = UDim.new(0, 8)
    sac.Parent = searchArea

    local box, _ = UI.makeInput(searchArea, "Cari asset (model, foto, sound)…", 44)
    box.Size = UDim2.new(1, -90, 1, 0)

    local searchBtn = UI.makeButton(searchArea, "Cari", 70, 32, T.Accent)
    searchBtn.Position = UDim2.new(1, -78, 0, 6)

    -- category
    local catRow = Instance.new("Frame")
    catRow.BackgroundTransparency = 1
    catRow.Size = UDim2.new(1, 0, 0, 32)
    catRow.Position = UDim2.new(0, 0, 0, 50)
    catRow.Parent = assetTab

    local catLayout = Instance.new("UIListLayout")
    catLayout.FillDirection = Enum.FillDirection.Horizontal
    catLayout.Padding = UDim.new(0, 4)
    catLayout.Parent = catRow

    local categories = {
        {id = "model", name = "Model", category = "Models"},
        {id = "image", name = "Foto", category = "Decals"},
        {id = "audio", name = "Sound", category = "Audio"},
    }

    local currentCat = "model"
    local catButtons = {}

    for i, cat in ipairs(categories) do
        local b = UI.makeButton(catRow, cat.name, 80, 32, i == 1 and T.Accent or T.Surface)
        b.TextColor3 = i == 1 and Color3.new(0,0,0) or T.Dim
        b.MouseButton1Click:Connect(function()
            currentCat = cat.id
            for cid, cb in pairs(catButtons) do
                local active = cid == cat.id
                cb.BackgroundColor3 = active and T.Accent or T.Surface
                cb.TextColor3 = active and Color3.new(0,0,0) or T.Dim
            end
        end)
        catButtons[cat.id] = b
    end

    -- list
    local listScroll = UI.makeScroll(assetTab)
    listScroll.Size = UDim2.new(1, 0, 1, -90)
    listScroll.Position = UDim2.new(0, 0, 0, 90)

    local function clearList()
        for _, c in ipairs(listScroll:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end
    end

    local function addItem(id, name, typeLabel)
        local item = Instance.new("Frame")
        item.BackgroundColor3 = T.Surface
        item.BorderSizePixel = 0
        item.Size = UDim2.new(1, 0, 0, 56)
        item.Parent = listScroll

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 8)
        c.Parent = item

        local nameL = UI.makeLabel(item, name, 18, T.Text, true)
        nameL.Position = UDim2.new(0, 12, 0, 8)
        nameL.Size = UDim2.new(1, -90, 0, 18)

        local idL = UI.makeLabel(item, "ID: " .. id .. " · " .. typeLabel, 14, T.Dim, false)
        idL.Position = UDim2.new(0, 12, 0, 28)
        idL.Size = UDim2.new(1, -90, 0, 14)

        local copyBtn = UI.makeButton(item, "COPY ID", 66, 28, T.Accent)
        copyBtn.Position = UDim2.new(1, -74, 0, 14)
        copyBtn.TextSize = 10
        copyBtn.MouseButton1Click:Connect(function()
            U.copy(tostring(id))
            copyBtn.Text = "OK!"
            task.wait(1)
            copyBtn.Text = "COPY ID"
        end)
    end

    local function search()
        local keyword = box.Text
        if not keyword or keyword == "" then return end
        clearList()
        local cat = nil
        for _, c in ipairs(categories) do
            if c.id == currentCat then cat = c break end
        end
        if not cat then return end

        local url = config.AssetApiBase
            .. "?category=" .. cat.category
            .. "&keyword=" .. game:GetService("HttpService"):UrlEncode(keyword)
            .. "&limit=" .. tostring(config.AssetLimit)

        searchBtn.Text = "…"
        searchBtn.BackgroundColor3 = T.Dim

        task.spawn(function()
            local res = U.get(url, {["Accept"] = "application/json"})
            searchBtn.Text = "Cari"
            searchBtn.BackgroundColor3 = T.Accent

            if not res.ok then
                addItem("ERR", "HTTP " .. tostring(res.status or res.err), "error")
                return
            end

            local data = U.jsonDecode(res.body)
            if not data or not data.data then
                addItem("ERR", "response tidak valid", "error")
                return
            end

            for _, entry in ipairs(data.data) do
                addItem(entry.id, entry.name or "Asset", cat.name)
            end

            if #data.data == 0 then
                addItem("ERR", "tidak ada hasil", "info")
            end
        end)
    end

    searchBtn.MouseButton1Click:Connect(search)
    box.FocusLost:Connect(function(enter)
        if enter then search() end
    end)

    return {}
end
