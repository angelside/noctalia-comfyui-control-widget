# ComfyUI Control Plugin for Noctalia v5

> A Noctalia v5 plugin that controls and monitors ComfyUI through a systemd user service.

![ComfyUI Controller screenshot](assets/screenshot.webp)

## Requirements

- Noctalia V5 (Plugin API 31)


## Installation

This is an unofficial Noctalia plugin.

### Method 1: Git clone

Clone the repository directly into Noctalia's plugin directory:

```bash
git clone https://github.com/angelside/noctalia-comfyui-control-widget.git ~/.local/share/noctalia/plugins/noctalia-comfyui-control-widget
```

### Method 2: Download ZIP

1. Open the repository on GitHub.
2. Select **Code → Download ZIP**.
3. Extract the downloaded archive.
4. Copy the plugin folder into:

`~/.local/share/noctalia/plugins/`

5. Make sure `manifest.json` is directly inside the plugin directory.

### Enable the plugin

1. Open **Noctalia Settings**.
2. Navigate to **Plugins**.
3. Find the plugin in the available plugins list.
4. Enable it.

If the plugin does not appear, restart Noctalia and check again.


## Features

- Displays the current status of the ComfyUI service (running, stopped, failed, unknown)
- Left-click and right-click context menu with Start/Stop options
- Automatic periodic status polling
- Configurable service name and refresh interval
- Optional widget text label, which can be shown or hidden through widget settings
- Middle-click the widget to open its settings


### Widget Display

The widget displays the ComfyUI service status using an icon and color:

- Green server icon (`server`) when running
- Red server-off icon (`server-off`) when stopped
- Server icon (`server`) when starting or stopping
- Grey server icon (`server`) when the status cannot be determined

The widget displays `ComfyUI` as its text label by default. You can hide the label using the **Show text** setting. Hovering over the widget shows the current service status in a tooltip.


### Context Menu

Right-clicking or left-clicking the widget opens a menu with:

- **Start ComfyUI** button, enabled when the service is not running
- **Stop ComfyUI** button, enabled when the service is not stopped


## Configuration

The plugin supports the following settings:

- `service_name`: Name of the systemd user service to control (default: `comfyui.service`)
- `refresh_interval`: How often to check service status in seconds (default: `5`, minimum: `1`, maximum: `30`)
- `show_text`: Show or hide the `ComfyUI` text label on the widget (default: `true`)


## ComfyUI Systemd Service

This plugin controls ComfyUI through a systemd user service. If you have not configured the service yet, follow the [ComfyUI User Service Setup Guide](docs/comfyui-systemd-service.md).

Once configured, the plugin lets you start and stop ComfyUI directly from the Noctalia bar widget.


## License

MIT License


## Development

This plugin is developed as part of the Noctalia v5 plugin ecosystem.
