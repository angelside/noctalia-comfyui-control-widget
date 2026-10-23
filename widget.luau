--!nonstrict

local serviceName = "comfyui.service"

-- Get theme colors if available (API level 31+)
local primaryColor = noctalia.getColor("primary") or "#F44336"
local tertiaryColor = noctalia.getColor("tertiary") or "#4CAF50"
local errorColor = noctalia.getColor("error") or "#F44336"
local onSurfaceColor = noctalia.getColor("on_surface") or "#9E9E9E"

local function updateWidget()
    local command = {"systemctl", "--user", "is-active", serviceName}

    -- Run the command asynchronously to avoid blocking the UI
    noctalia.runAsync(command, function(result)
        local status = "Unknown"
        local glyph
        local color

        if result and result.stdout then
            local output = noctalia.string.trim(result.stdout)

            -- Determine the status based on the command output
            if result.exitCode == 0 and output == "active" then
                status = "Running"
                glyph = "server"
                color = tertiaryColor
            elseif output == "inactive" then
                status = "Stopped"
                glyph = "server-off"
                color = primaryColor
            elseif output == "failed" then
                status = "Failed"
                glyph = "server-off"
                color = errorColor
            else
                status = output
                glyph = "server"
                color = onSurfaceColor
            end
        end

        --- Update the widget with the new status
        barWidget.setText("ComfyUI")
        barWidget.setGlyph(glyph)
        barWidget.setGlyphColor(color)
        barWidget.setTooltip("ComfyUI Service: " .. status)
    end)
end

--
-- Built-in functions
--

local refreshInterval = tonumber(noctalia.getConfig("refresh_interval")) or 5
noctalia.setUpdateInterval(refreshInterval * 1000)

function update()
    --noctalia.setUpdateInterval(5000)

    updateWidget()
end

function onClick()
    noctalia.togglePanel("angelside/comfyui-control:menu")
end

function onRightClick()
    noctalia.togglePanel("angelside/comfyui-control:menu")
end
