# Contributing to innie 🏢

> *"We are, all of us, so grateful to be here."*

Welcome to the Macrodata Refinement department. Before you begin refining, please review the following guidelines.

## How to contribute

1. **Fork** the repository and create a branch from `main`.
2. **Make your changes.** Keep pull requests focused — one improvement per PR.
3. **Test your changes** — run the test suite locally before opening a PR:
   ```bash
   bats test/install.bats
   ```
4. **Open a pull request** with a clear title and description.

## Adding a new tool

To add a new tool to the setup script:

1. Add an idempotent install block to `install.sh` following the existing pattern:
   ```bash
   # N. Tool name — short description
   if ! command -v <tool> &>/dev/null; then
     echo "🔧 <Severance-flavoured install message>..."
     brew install <tool>
   else
     echo "🔧 <Severance-flavoured skip message>."
   fi
   ```
2. Add corresponding **bats** test cases to `test/install.bats` (install path + skip path).
3. Update the **What gets refined** table in `README.md`.
4. Add the tool to the **Verify command-line tools** step in `.github/workflows/ci.yml`.

## Code style

- Shell scripts must pass `shellcheck` without warnings.
- Echo messages should carry a light Severance theme — keep it fun, keep it work-appropriate.
- Commit messages should be concise and written in the imperative mood.

## Reporting issues

Please open a GitHub issue describing:
- What you expected to happen
- What actually happened
- Your macOS version and any relevant context

---

*The work is mysterious and important. Praise Kier.* 🫱
