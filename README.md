# ClearDesk releases

Installers and update manifests for the ClearDesk desktop agent.

Installed agents read `latest.yml` from the newest release here to check for
updates, so this repo is public: the agent has to fetch it without credentials,
and a private feed would mean shipping a GitHub token to every PC running the
agent. Only build output lives here — the source is elsewhere and stays private.

Downloading an installer gets you nothing on its own: the agent is inert until
it is enrolled and signed in against a ClearDesk workspace.

## Releases

| File | What it is |
|---|---|
| `cleardesk-<version>-setup.exe` | Windows installer (per-user, no admin rights needed) |
| `cleardesk-<version>-setup.exe.blockmap` | Lets agents download only the changed parts of an update |
| `latest.yml` | The manifest agents poll: version, size and checksum |

Published with `npm run release:win` from the main repo.
