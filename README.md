# innie
An idempotent setup script for my work laptop on macOS. A fun reference to the Apple TV Series, Severance. 

## Install

Run the following single command to install all dependencies:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/bobbravo2/innie/main/install.sh)"
```

## What gets installed

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
| [Google Workspace CLI (`gws`)](https://github.com/googleworkspace/cli) | `brew install googleworkspace-cli` |

The script is idempotent — re-running it is safe and will skip anything already installed.
