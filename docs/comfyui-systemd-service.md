
# Create ComfyUI User Service

Create a systemd user service for ComfyUI that runs your existing `uv run main.py` command in the background. The service will run under your normal user account, without sudo, and will use systemd to manage its lifecycle.


## 1. Find your ComfyUI project directory
Open a terminal in your existing ComfyUI directory and check its absolute path:

```bash
pwd
```

Also check whether you normally pass any additional arguments to `uv run main.py`. Those should be preserved in the service configuration.


## 2. Find the absolute path to uv
Run:
```bash
command -v uv
```

For example, it might return `/usr/bin/uv` or a path inside your home directory. Use the actual result in the service file because systemd does not necessarily inherit your fish shell's PATH.


## 3. Create the service file
Create the user service directory if it does not exist:

```bash
mkdir -p ~/.config/systemd/user
```

Open the service file in your preferred editor:

```bash
nano ~/.config/systemd/user/comfyui.service
```

Paste the following configuration, replacing the two example paths with your actual ComfyUI directory and uv executable path.

```bash
[Unit]
Description=ComfyUI
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/angelside/Projects/code/AI/ComfyUI-latest
ExecStart=/usr/bin/uv run main.py
Restart=on-failure
RestartSec=5
SuccessExitStatus=143

[Install]
WantedBy=default.target
```

For example, if your ComfyUI directory is elsewhere, update WorkingDirectory. Also ensure ExecStart uses the actual path returned by command -v uv.

The configuration restarts ComfyUI if it crashes, but does not automatically start it at login unless you enable it in a later step.

Save and close the file.


## 4. Start ComfyUI through systemd
If you currently have ComfyUI running in a terminal, stop that instance first with Ctrl+C to avoid starting a duplicate.

Then run:

```bash
systemctl --user daemon-reload
systemctl --user start comfyui
```

Check whether it started successfully:

```bash
systemctl --user status comfyui
```

To inspect live logs:
```bash
journalctl --user -u comfyui -f
```

Press Ctrl+C to exit the log viewer. This does not stop ComfyUI.


## 5. Manage ComfyUI

You can now control it without opening the project directory.

| Action     | Command                                      |
|------------|----------------------------------------------|
| Start      | `systemctl --user start comfyui`             |
| Stop       | `systemctl --user stop comfyui`              |
| Restart    | `systemctl --user restart comfyui`           |
| Is active  | `systemctl --user is-active comfyui`          |
| Status     | `systemctl --user status comfyui`          |
| Logs       | `journalctl --user -u comfyui -n 100`         |
| Live logs  | `journalctl --user -u comfyui -f`             |

To start ComfyUI automatically when you log in:
```bash
systemctl --user enable comfyui
```

You can leave automatic startup disabled if you prefer starting it through Noctalia.
