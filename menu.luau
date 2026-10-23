--!nonstrict

local serviceName = "comfyui.service"
local serviceStatus = "checking"

local function openSettings()
    noctalia.openSettings()
end

local function render()
    local startEnabled =
        serviceStatus == "stopped" or
        serviceStatus == "failed"

    local stopEnabled = serviceStatus == "running"

    panel.render(
        ui.column({
            gap = 8,
            padding = 12,
            fill = true,
        }, {
            ui.label({
                text = "ComfyUI Service",
                fontSize = 14,
                fontWeight = "bold",
                color = noctalia.getColor("primary") or "#007acc",
            }),

            ui.separator(),

            ui.label({
                text = "Status: " .. serviceStatus,
                fontSize = 12,
            }),

            ui.button({
                text = "Start ComfyUI",
                glyph = "player-play",
                variant = "outline",
                width = "fill",
                enabled = startEnabled,
                onClick = function()
                    serviceStatus = "starting"
                    render()

                    noctalia.runAsync({
                        "systemctl", "--user", "start", serviceName
                    }, function(result)
                        refreshStatus()
                    end)
                end,
            }),

            ui.button({
                text = "Stop ComfyUI",
                glyph = "player-stop",
                variant = "outline",
                width = "fill",
                enabled = stopEnabled,
                onClick = function()
                    serviceStatus = "stopping"
                    render()

                    noctalia.runAsync({
                        "systemctl", "--user", "stop", serviceName
                    }, function(result)
                        refreshStatus()
                    end)
                end,
            })
        })
    )
end

function refreshStatus()
    noctalia.runAsync({
        "systemctl", "--user", "is-active", serviceName
    }, function(result)
        local output = ""

        if result and result.stdout then
            output = string.match(
                result.stdout,
                "^%s*(.-)%s*$"
            ) or ""
        end

        if output == "active" then
            serviceStatus = "running"
        elseif output == "inactive" then
            serviceStatus = "stopped"
        elseif output == "failed" then
            serviceStatus = "failed"
        elseif output == "activating" then
            serviceStatus = "starting"
        elseif output == "deactivating" then
            serviceStatus = "stopping"
        else
            serviceStatus = "unknown"
        end

        render()
    end)
end

function onOpen()
    serviceStatus = "checking"
    render()
    refreshStatus()
end
