# ClearDesk releases

Installers and update manifests for the ClearDesk desktop agent.

## Install on a PC

Open PowerShell and paste:

```powershell
irm https://raw.githubusercontent.com/Shubhamji038/ClearDesk-releases/main/install.ps1 | iex
```

That downloads the newest installer, installs it silently and starts the agent,
which asks the employee to sign in once. Run it as the **employee's own user**,
not as an administrator — the agent installs per-user, so it lands in whichever
profile runs it.

To install a specific version instead of the newest:

```powershell
$env:CLEARDESK_VERSION='v0.2.0'; irm https://raw.githubusercontent.com/Shubhamji038/ClearDesk-releases/main/install.ps1 | iex
```

You can also download `cleardesk-<version>-setup.exe` from
[Releases](../../releases/latest) and run it by hand. The builds aren't
code-signed, so Windows SmartScreen warns first: choose **More info** ->
**Run anyway**.

Installing once is enough. Agents check for new releases here by themselves and
update in the background.

## What's in a release

| File | What it is |
|---|---|
| `cleardesk-<version>-setup.exe` | Windows installer (per-user, no admin rights needed) |
| `cleardesk-<version>-setup.exe.blockmap` | Lets agents download only the changed parts of an update |
| `latest.yml` | The manifest agents poll: version, size and checksum |

"Source code (zip/tar.gz)" is added automatically by GitHub to every release. It
is a snapshot of this repo — the README and the install script, nothing else.

## Why this repo is public

Installed agents fetch `latest.yml` without credentials, so the feed has to be
reachable anonymously; a private feed would mean shipping a GitHub token to
every PC running the agent. Only build output lives here. The source is in a
separate private repo.

Downloading an installer gets you nothing on its own: the agent is inert until
it is enrolled and signed in against a ClearDesk workspace.
