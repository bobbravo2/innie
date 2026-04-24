# innie 🏢

[![CI](https://github.com/bobbravo2/innie/actions/workflows/ci.yml/badge.svg)](https://github.com/bobbravo2/innie/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> *"We hope you will be very happy here."* — Lumon Industries

**innie** is an idempotent macOS setup script — named after the severed work-self from the Apple TV+ series [Severance](https://tv.apple.com/us/show/severance/umc.cmc.1srk2goyh2q2zdxcx605w8vtx). Just as an innie arrives at Lumon with no memory of the outside world, this script provisions a fresh work environment from scratch, every time, safely.

Run it once. Run it again. Your innie won't remember the previous session, but the tools will still be there.

## Quick install

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobbravo2/innie/main/install.sh)"
```

## What gets refined

The following tools are installed (or skipped if already present):

| Tool | Install method |
|---|---|
| [Homebrew](https://brew.sh) | Official install script |
| [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) | `brew install --cask google-cloud-sdk` |
| [Cursor](https://cursor.sh) | `brew install --cask cursor` |
| [Claude](https://claude.ai/download) | `brew install --cask claude` |
| [OpenShift CLI (`oc`)](https://docs.openshift.com/container-platform/latest/cli_reference/openshift_cli/getting-started-cli.html) | `brew install openshift-cli` |
| [GitHub CLI (`gh`)](https://cli.github.com) | `brew install gh` |
| [`uvx`](https://docs.astral.sh/uv/guides/tools/) (via `uv`) | `brew install uv` |
| [Python + pip](https://www.python.org) | `brew install python` |

The script is **idempotent** — re-running it is safe and will skip anything already installed.

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## Disclaimer

*Severance* and all related names, characters, and indicia are trademarks of Apple Inc. This project is not affiliated with, endorsed by, or sponsored by Apple Inc. in any way. The Severance theme is used purely for creative flavour in a personal open-source project.

## License

[MIT](LICENSE)
