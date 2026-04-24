# Contributing to innie 🏢

> *"We are, all of us, so grateful to be here."*

Welcome to the Macrodata Refinement department. This is your **employee handbook** for contributing to innie — the idempotent macOS setup script that keeps the Severed Floor humming.

---

## Orientation — your first day on the Severed Floor

1. **Fork** this repository and create a branch from `main`.
2. **Clone** your fork and make your changes. Keep pull requests focused — one refinement per PR.
3. **Run the test suite** before opening a PR:
   ```bash
   bats test/install.bats
   ```
   (Requires [Bats](https://github.com/bats-core/bats-core) and `shellcheck` on your machine.)
4. **Open a pull request** with a clear title and description. The PR template will walk you through the checklist.

---

## Requisitioning a new tool

To add a new tool to the setup script, complete **all four** steps below. Skipping one is how we end up in the Break Room.

Need the Board to approve something first? [Requisition a new tool](https://github.com/bobbravo2/innie/issues/new/choose).

### Checklist

1. **`install.sh`** — Add a numbered, idempotent block following the existing pattern:
   - **CLI tools** (binary on `PATH`): use `command -v <tool>` and `brew install <formula>`.
   - **GUI apps** (Homebrew cask): use `brew list --cask <name>` and `brew install --cask <name>`.
2. **`test/install.bats`** — Add **two** tests: one where the tool is missing (install path), one where it is present (skip path). Assert on distinctive substrings from your `echo` lines.
3. **`README.md`** — Add a row to **What gets refined**.
4. **`.github/workflows/ci.yml`** — For CLI tools only, add a line under **Verify command-line tools** (e.g. `<tool> --version`). **GUI-only casks** often have no CLI — do not add a verify line; note it in the PR instead.

### Worked example: adding `ripgrep` (`rg`)

*Hypothetical* — illustrates every file a real PR would touch.

**1. `install.sh`** (new block after the last numbered section):

```bash
# 11. ripgrep — fast search for the filing cabinets
if ! command -v rg &>/dev/null; then
  echo "📂 ripgrep not found. Lumon requires orderly search. Installing..."
  brew install ripgrep
else
  echo "📂 ripgrep is already catalogued on the floor."
fi
```

**2. `test/install.bats`** — install path (mock has no `rg`):

```bash
@test "installs ripgrep when rg is not on PATH" {
  run env PATH="$MOCK_BIN" /bin/bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"ripgrep not found"* ]]
}
```

Skip path (stub `rg` in `$MOCK_BIN`):

```bash
@test "skips ripgrep when rg is already installed" {
  cat > "$MOCK_BIN/rg" <<'EOF'
#!/bin/bash
exit 0
EOF
  chmod +x "$MOCK_BIN/rg"

  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  [[ "$output" == *"ripgrep is already catalogued"* ]]
}
```

Also add `rg` to the **"all tools already present"** test's stub list and expected output, if that test exists.

**3. `README.md`** — new table row:

```markdown
| [ripgrep (`rg`)](https://github.com/BurntSushi/ripgrep) | `brew install ripgrep` |
```

**4. `.github/workflows/ci.yml`** — under verify:

```bash
rg --version
```

---

## Departmental standards

- **`shellcheck`** — `install.sh` must pass with zero warnings (enforced in tests).
- **Echo messages** — Keep a light Severance / Lumon flavour. Fun is encouraged; cruelty to innies is not.
- **Commit messages** — Short, imperative mood (`Add ripgrep to install script`).
- **Idempotency** — Re-running `install.sh` must never break a machine that already has the tool.

---

## Good first refinements

Look for issues labelled **`good-first-refinement`**. The Board has pre-approved those tasks for new hires.

---

## Reporting a workplace incident

Something explode in the elevator? [Create a new workplace incident](https://github.com/bobbravo2/innie/issues/new/choose) with your macOS version, shell, and what you expected vs. what happened.

---

## The Lumon code

We follow the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/) — treat fellow refiners with respect. The work is mysterious and important; the people are not mysterious and deserve kindness.

---

*The work is mysterious and important. Praise Kier.* 🫱
