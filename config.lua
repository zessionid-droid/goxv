-- ============================================================
-- GOxv Config
-- Edit file ini di GitHub untuk ganti API key, model, dsb.
-- Setelah push, semua user yang jalankan loader akan pakai config baru.
-- ============================================================

return {
    -- ============ API ============
    OpenRouterKey = "sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    OpenRouterUrl = "https://openrouter.ai/api/v1/chat/completions",
    Model         = "deepseek/deepseek-v4-flash:free",
    MaxTokens     = 1500,
    Temperature   = 0.7,
    SystemPrompt  = "You are a Roblox Lua scripting assistant. Answer in Indonesian. If the user asks for code, provide complete runnable Luau in a single code block. Be concise.",

    -- ============ UI ============
    WindowWidth   = 420,
    WindowHeight  = 540,
    MinWidth      = 320,
    MinHeight     = 400,
    MaxWidth      = 620,
    MaxHeight     = 760,
    AccentColor   = Color3.fromRGB(0, 200, 255),
    Accent2Color  = Color3.fromRGB(200, 60, 255),

    -- ============ ASSET BROWSER ============
    AssetApiBase  = "https://catalog.roblox.com/v1/search/items",
    AssetLimit    = 20,
    AssetCategories = {
        {id = "model", name = "Model", category = "Models"},
        {id = "image", name = "Foto",  category = "Decals"},
        {id = "audio", name = "Sound", category = "Audio"},
    },

    -- ============ MISC ============
    Version       = "1.0.0",
    Name          = "GOxv",
}
