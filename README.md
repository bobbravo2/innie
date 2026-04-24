# innie 🏢

[![CI](https://github.com/bobbravo2/innie/actions/workflows/ci.yml/badge.svg)](https://github.com/bobbravo2/innie/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](CONTRIBUTING.md)

> *"We hope you will be very happy here."* — Lumon Industries

**innie** is an idempotent macOS setup script — named after the severed work-self from the Apple TV+ series [Severance](https://tv.apple.com/us/show/severance/umc.cmc.1srk2goyh2q2zdxcx605w8vtx). Think of it as the **Macrodata Refinement department onboarding packet**: your outie has generously volunteered you for this floor. This handbook provisions your workstation. You will not remember why.

Just as an innie arrives at Lumon with no memory of the outside world, this script provisions a fresh work environment from scratch, every time, safely.

Run it once. Run it again. Your innie won't remember the previous session, but the tools will still be there.

## Quick install

Stable (latest release):

```bash
/bin/bash -c "$(curl -fsSL https://github.com/bobbravo2/innie/releases/latest/download/install.sh)"
```

Bleeding edge (main branch):

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
| [Miro](https://miro.com/apps/) | `brew install --cask miro` |
| [Google Workspace CLI (`gws`)](https://github.com/googleworkspace/cli) | `brew install googleworkspace-cli` |

The script is **idempotent** — re-running it is safe and will skip anything already installed.

## Your first refinement

Want to add a tool to the Severed Floor? The pattern is always the same:

1. **`install.sh`** — Add a numbered, idempotent block (see existing sections for `command -v` vs `brew list --cask` patterns).
2. **`test/install.bats`** — Add install + skip tests that assert on your new log substrings.
3. **`README.md`** — Add a row to the table above.
4. **`.github/workflows/ci.yml`** — If the tool exposes a CLI, add a verify line to the E2E step. (GUI-only casks like Miro have no `command -v` binary — skip CI verification for those.)

Full orientation, a worked example, and departmental standards live in [CONTRIBUTING.md](CONTRIBUTING.md).

## Contributing

Contributions are welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for the employee handbook.

## Disclaimer

*Severance* and all related names, characters, and indicia are trademarks of Apple Inc. This project is not affiliated with, endorsed by, or sponsored by Apple Inc. in any way. The Severance theme is used purely for creative flavour in a personal open-source project.

## License

[MIT](LICENSE)

---

*Please enjoy all tool installations equally.*
