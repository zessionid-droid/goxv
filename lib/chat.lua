-- ============================================================
-- GOxv Chat module (DeepSeek via OpenRouter)
-- ============================================================

return function(U, T, config, UI)

    local HttpService = game:GetService("HttpService")

    local chatTab = UI.addTab("chat", "AI Chat")
    UI.switchTab("chat")

    local scroll = UI.makeScroll(chatTab)
    scroll.Size = UDim2.new(1, 0, 1, -70)

    local inputArea = Instance.new("Frame")
    inputArea.BackgroundColor3 = T.Surface
    inputArea.BorderSizePixel = 0
    inputArea.Size = UDim2.new(1, 0, 0, 60)
    inputArea.Position = UDim2.new(0, 0, 1, -60)
    inputArea.Parent = chatTab

    local iac = Instance.new("UICorner")
    iac.CornerRadius = UDim.new(0, 10)
    iac.Parent = inputArea

    local box, _ = UI.makeInput(inputArea, "Tanya DeepSeek… (contoh: 'buat script jump boost')", 60)
    box.Size = UDim2.new(1, -80, 1, 0)
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.TextWrapped = true

    local sendBtn = UI.makeButton(inputArea, "Kirim", 60, 40, T.Accent)
    sendBtn.Position = UDim2.new(1, -70, 0, 10)

    -- chat state
    local history = {}

    local function append(text, isUser, isCode)
        UI.makeBubble(scroll, text, isUser, isCode)
        -- scroll ke bawah
        task.wait()
        scroll.CanvasPosition = Vector2.new(0, scroll.AbsoluteCanvasSize.Y)
    end

    local function send()
        local prompt = box.Text
        if not prompt or prompt == "" then return end
        if not config.OpenRouterKey or config.OpenRouterKey:find("xxxxx") then
            append("ERROR: OpenRouterKey belum diisi di config.lua", false, false)
            return
        end

        append(prompt, true, false)
        history[#history + 1] = {role = "user", content = prompt}

        box.Text = ""
        sendBtn.Text = "…"
        sendBtn.BackgroundColor3 = T.Dim

        local body = U.jsonEncode({
            model = config.Model,
            messages = (function()
                local msgs = {{role = "system", content = config.SystemPrompt}}
                for _, m in ipairs(history) do
                    table.insert(msgs, m)
                end
                return msgs
            end)(),
            max_tokens = config.MaxTokens,
            temperature = config.Temperature,
        })

        task.spawn(function()
            local res = U.post(config.OpenRouterUrl, {
                ["Authorization"] = "Bearer " .. config.OpenRouterKey,
                ["Content-Type"] = "application/json",
                ["HTTP-Referer"] = "https://roblox.com",
                ["X-Title"] = "GOxv",
            }, body)

            if not res.ok then
                append("ERROR " .. tostring(res.status or res.err), false, false)
                sendBtn.Text = "Kirim"
                sendBtn.BackgroundColor3 = T.Accent
                return
            end

            local data = U.jsonDecode(res.body)
            if not data or not data.choices or not data.choices[1] then
                append("ERROR: response tidak valid", false, false)
                sendBtn.Text = "Kirim"
                sendBtn.BackgroundColor3 = T.Accent
                return
            end

            local reply = data.choices[1].message.content
            history[#history + 1] = {role = "assistant", content = reply}
            local hasCode = U.hasCode(reply)
            append(reply, false, hasCode)

            sendBtn.Text = "Kirim"
            sendBtn.BackgroundColor3 = T.Accent
        end)
    end

    sendBtn.MouseButton1Click:Connect(send)
    box.FocusLost:Connect(function(enter)
        if enter then send() end
    end)

    return {
        send = send,
    }
end
