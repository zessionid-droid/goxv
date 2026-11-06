-- ============================================================
-- GOxv Utils
-- ============================================================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local U = {}

-- log
function U.log(...)
    print("[GOxv]", ...)
end

-- tween shortcut
function U.tween(obj, props, duration, style)
    duration = duration or 0.2
    style = style or Enum.EasingStyle.Quad
    local tw = TweenService:Create(obj, TweenInfo.new(duration, style, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

-- copy ke clipboard (support executor function dan fallback)
function U.copy(text)
    if setclipboard then
        pcall(setclipboard, text)
        return true
    end
    if toclipboard then
        pcall(toclipboard, text)
        return true
    end
    return false
end

-- http request wrapper
function U.post(url, headers, body)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then
        return { ok = false, err = "no http function" }
    end
    local ok, res = pcall(function()
        return req({
            Url = url,
            Method = "POST",
            Headers = headers,
            Body = body,
        })
    end)
    if not ok or not res then
        return { ok = false, err = tostring(res) }
    end
    return {
        ok = res.StatusCode == 200,
        status = res.StatusCode,
        body = res.Body,
    }
end

function U.get(url, headers)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if not req then
        return { ok = false, err = "no http function" }
    end
    local ok, res = pcall(function()
        return req({
            Url = url,
            Method = "GET",
            Headers = headers or {},
        })
    end)
    if not ok or not res then
        return { ok = false, err = tostring(res) }
    end
    return {
        ok = res.StatusCode == 200,
        status = res.StatusCode,
        body = res.Body,
    }
end

function U.jsonEncode(t)
    return HttpService:JSONEncode(t)
end

function U.jsonDecode(s)
    local ok, res = pcall(function() return HttpService:JSONDecode(s) end)
    if ok then return res end
    return nil
end

-- cleanup old gui
function U.cleanup(names)
    for _, name in ipairs(names) do
        local old = CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
    end
end

-- detect code block
function U.hasCode(text)
    return text:find("```") ~= nil
end

-- extract code blocks
function U.extractCode(text)
    local blocks = {}
    for code in text:gmatch("```[%w]*\n(.-)```") do
        table.insert(blocks, code)
    end
    return blocks
end

return U
