# codex-profile

Use multiple [OpenAI Codex CLI](https://github.com/openai/codex) accounts locally
without mixing credentials, sessions, history, or configuration clutter.

`codex-profile` starts Codex with a dedicated `CODEX_HOME` per profile. Use one
profile for work, another for personal, and as many named profiles as you need.

> This is the Codex sibling of
> [`claude-profile`](https://github.com/0xmapachex/claude-profile) — same idea,
> same commands, for the Codex CLI.

## Install

```sh
npm install -g @0xmapache/codex-profile
```

This installs:

- `codex-profile`
- `codex-profile-usage`

## Quick Start

Create and open a profile:

```sh
codex-profile personal
```

Inside Codex, log in with the account for that profile:

```sh
codex login
```

Open the same profile later:

```sh
codex-profile personal
```

After the first launch, a shortcut named `codex-<profile>` is created in
`~/.local/bin`, so you can also reopen it with:

```sh
codex-personal
```

Create another profile:

```sh
codex-profile work
```

Inside that session, run `codex login` with your other Codex account.

List profiles:

```sh
codex-profile --list
```

Remove a profile:

```sh
codex-profile --remove work
```

Removal is non-destructive. The profile is moved to:

```sh
~/.codex-profiles/.trash/<profile>-<timestamp>
```

Review local usage across logged-in profiles:

```sh
codex-profile-usage
```

## Permissions

Profile launches use Codex's approvals/sandbox bypass by default:

```sh
codex-profile work
```

This appends `--dangerously-bypass-approvals-and-sandbox`, keeping the profile
command simple and matching the common local agent workflow.

## Profile Storage and Shared Config

Profiles live under:

```sh
~/.codex-profiles/<profile>
```

Each profile has isolated:

- credentials (`auth.json`)
- sessions
- history
- cache
- project state

Profiles are bootstrapped from your main `~/.codex` config:

- `config.toml` is re-synced from `~/.codex/config.toml` on every launch, so
  profiles always follow your main configuration. Auth-bearing keys and `[*.env]`
  tables are stripped during the sync. Credentials live in `auth.json`, which is
  never copied — each profile keeps its own.
- `AGENTS.md`, `prompts`, `skills`, and `rules` are symlinked if they exist.

This means shared instructions and settings update everywhere, while
account-specific state stays separate.

If you want a profile to keep its own local `config.toml` edits instead of
following `~/.codex`, disable the launch sync:

```sh
CODEX_PROFILE_SYNC_CONFIG=0 codex-profile work
```

To sync a profile's config without launching it:

```sh
codex-profile --sync-config work
```

## Safety

Before starting Codex, `codex-profile` removes auth/provider environment
variables such as `OPENAI_API_KEY`, `OPENAI_BASE_URL`, and `CODEX_API_KEY`. A
profile should use its own `codex login` session, not an API key or token
inherited from your shell.

Copied `config.toml` files are sanitized by removing `[*.env]` tables and any
auth-bearing keys (`api_key`, `token`, `secret`, etc.).

## Usage Reports

```sh
codex-profile-usage
codex-profile-usage monthly
codex-profile-usage session
codex-profile-usage daily --since 2026-06-01
```

`codex-profile-usage` checks which profiles are logged in with
`codex login status`, then summarizes local Codex usage logs with
`ccusage codex`.

This reports local token and estimated-cost history. It does not read API keys
or call undocumented live quota endpoints.

## Terminal Titles

Interactive launches set the terminal title to the profile name
(`codex:<profile>`), so you can tell which account a window belongs to.

Customize or disable the terminal title:

```sh
CODEX_PROFILE_TITLE_PREFIX="cx:" codex-profile work
CODEX_PROFILE_SET_TERMINAL_TITLE=0 codex-profile work
```

## Launch Shortcuts

Each profile launch also creates `~/.local/bin/codex-<profile>`, so the second
time around you can start a profile directly:

```sh
codex-work
codex-personal
```

Shortcuts are small generated scripts; removing a profile removes its shortcut,
and existing commands not created by codex-profile are never overwritten.
Customize or disable:

```sh
CODEX_PROFILE_SHORTCUT_DIR="$HOME/bin" codex-profile work
CODEX_PROFILE_SHORTCUTS=0 codex-profile work
```

## Environment Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `CODEX_PROFILES_ROOT` | `~/.codex-profiles` | Where profiles are stored |
| `CODEX_PROFILE_SOURCE_CONFIG` | `~/.codex` | Config bootstrapped/synced from |
| `CODEX_PROFILE_SHARED_ITEMS` | `AGENTS.md prompts skills rules` | Items symlinked from source config |
| `CODEX_PROFILE_SYNC_CONFIG` | `1` | Re-sync `config.toml` on every launch |
| `CODEX_PROFILE_SHORTCUT_DIR` | `~/.local/bin` | Where `codex-<profile>` shortcuts are written |
| `CODEX_PROFILE_SHORTCUTS` | `1` | Create launch shortcuts |
| `CODEX_PROFILE_SET_TERMINAL_TITLE` | `1` | Set the terminal title to the profile |
| `CODEX_PROFILE_TITLE_PREFIX` | `codex:` | Terminal title prefix |
| `CODEX_PROFILE_CODEX_BIN` | (auto) | Path to the `codex` binary |
| `CODEX_PROFILE_CCUSAGE_PACKAGE` | `ccusage@latest` | ccusage package used by `npx` |

## License

MIT
