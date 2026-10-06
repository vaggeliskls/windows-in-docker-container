# dockur/windows example

An alternative setup based on [dockur/windows](https://github.com/dockur/windows), which downloads Windows directly from Microsoft instead of using a Vagrant box. See the important notice in the [main README](../../README.md) for background.

## Run

```bash
cd examples/dockur
docker compose up -d
```

Open <http://localhost:8006> to watch the unattended install. The first start downloads the Windows ISO from Microsoft and installs it, so it takes a while and depends on your bandwidth. Once the desktop appears, `oem/install.bat` runs automatically and installs Chocolatey, enables the OpenSSH server, and turns on long path support. Its output is written to `C:\OEM\install.log` inside Windows.

Later starts boot the installed disk from `./windows` directly.

## Access

| | |
|---|---|
| Web viewer | <http://localhost:8006> |
| RDP | `localhost:3389`, user `vagrant`, password `vagrant` |
| SSH | `ssh vagrant@localhost -p 2222`, available once `install.bat` has finished |

## Notes

- `install.bat` runs only during the initial installation. To run it again, stop the container and delete the `windows/` folder, which triggers a fresh install.
- Keep each PowerShell call in `install.bat` on one line. dockur normalises the file, and batch line continuation inside quoted commands is fragile.
- The Windows Server 2022 download is a 180-day evaluation. Set the `KEY` variable in `compose.yml` to activate with a real key.
- Every available setting is documented in the dockur [environment variables](https://github.com/dockur/windows/blob/master/docs/environment.md) page.
