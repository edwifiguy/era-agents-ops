# MemPalace on External Drive — How It Works

## How MemPalace works (in this setup)

1. The CLI (`mempalace`) reads/writes its local data store at `~/.mempalace`.
2. We moved the canonical store to the external drive and linked home to it:
   - `~/.mempalace -> /media/era-estate/BCK-Up/AI-Systems/MemPalace/active/.mempalace-home`
3. This keeps one primary memory store while preserving compatibility with tools expecting `~/.mempalace`.

## External drive organization applied

- Canonical root:
  - `/media/era-estate/BCK-Up/AI-Systems/MemPalace`
- Layout:
  - `active/.mempalace-home` (live store)
  - `backups/` (safety snapshots)
  - `reports/` (duplicate scan and migration notes)

## Duplicate scan result

Exact duplicate found:
- `active/.mempalace-home/config.json`
- `backups/20260417-015801-local-mempalace/config.json`

This duplicate is expected (migration safety backup).

## Space cleanup recommendation

After confirming a few successful MemPalace sessions from the external store, remove old backup snapshot(s) in:
- `/media/era-estate/BCK-Up/AI-Systems/MemPalace/backups/`

Only keep the latest backup(s) needed for rollback.

