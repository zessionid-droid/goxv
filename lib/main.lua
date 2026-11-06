-- ============================================================
-- GOxv Main
-- ============================================================

return function(U, T, config, UI, chat, assets, settings)
    U.log("main · starting")

    -- wire keybind toggle
    local UserInputService = game:GetService("UserInputService")
    UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.RightShift then
            if UI.Main then
                UI.Main.Visible = not UI.Main.Visible
            end
        end
    end)

    U.log("main · ready")
end
