# innie

Scripts and customizations for my macOS development laptop.

## Useful CLI Utilities

* `brew` - [Homebrew](https://brew.sh/) - package manager for macOS
* `gh` - GitHub CLI (`brew install gh`) - create PRs, manage issues, etc.
* `claude` - [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) - AI coding agent in your terminal
* `bw` - [Bitwarden CLI](https://bitwarden.com/help/cli/) - manage password entries from the terminal (`brew install bitwarden-cli`)
* `oc` - OpenShift CLI - log into OpenShift clusters
* `k9s` - TUI for Kubernetes resources (`brew install k9s`)
* `jq` - Command-line JSON processor (`brew install jq`)

## Shell

Install [oh-my-zsh](https://ohmyz.sh/) for shell customization on macOS.

## Note-Taking

[Obsidian](https://obsidian.md/) for note-taking.

## Claude Settings

MCP servers:

```
claude mcp add playwright -s user -- npx -y @playwright/mcp@latest
claude mcp add memory -s user -- npx -y @modelcontextprotocol/server-memory@latest
```

## Other AI Tools

* [Cursor AI](https://cursor.com/) - AI-powered code editor
