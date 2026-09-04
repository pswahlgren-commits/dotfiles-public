# dotfiles

Hyprland, shell and terminal configuration for an [Omarchy](https://omarchy.org)
(Arch + Hyprland) desktop.

Deliberately small: this is a curated export of the parts that are worth
sharing, not a mirror of a home directory. Nothing here is machine-specific.

## Install

Uses [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory
is one package whose contents mirror `$HOME`.

```bash
git clone <this-repo> ~/dotfiles
cd ~/dotfiles
stow hypr bash foot git bin
```

Stow symlinks the files into place, so editing them here edits the live
config. Use `stow -D <package>` to remove a package again.

Then copy the monitor template and fill in your own hardware:

```bash
cp ~/.config/hypr/monitors.lua.example ~/.config/hypr/monitors.lua
```

## Packages

| Package | Contents |
| --- | --- |
| `hypr` | Hyprland config: window snapping keybindings, look & feel, input, per-machine monitor template |
| `bin` | `hypr-snap-window` and `hypr-tile-window` — the scripts the snap keybindings call |
| `bash` | `.bashrc` / `.bash_profile` (thin, on top of Omarchy's defaults) |
| `foot` | foot terminal config |
| `git` | git aliases and defaults; identity left as a placeholder |

## What's actually interesting here

Most of these files are thin overrides on top of Omarchy's own defaults. The
parts worth reading:

- **`bin/hypr-snap-window`** — Windows-style window snapping. Snapping to a
  plain half also pulls the next most-recently-focused window into the other
  half. Handles monitor scale, gaps and the bar's reserved space, and locks
  against overlapping invocations so key repeat can't make two copies race on
  the same window.
- **`bin/hypr-tile-window`** — `Alt+Left/Right` variant that uses Hyprland's
  real tiling instead of floating, because floating windows always render
  above tiled ones regardless of focus: two floating snapped windows will hide
  anything opened after them.
- **`hypr/.config/hypr/bindings.lua`** — two findings that cost real debugging
  time: numpad binds must be bound for *both* the NumLock-on and NumLock-off
  keysyms or they silently never fire, and some keyboards' "Print Screen" key
  actually emits `Super+Shift+S` rather than `PRINT`.
- **`hypr/.config/hypr/monitors.lua.example`** — why `cm = "auto"` rather than
  the experimental HDR modes, if you are on the Nvidia proprietary driver.

## Not included

Machine-specific and personal configuration is intentionally left out:
monitor hardware, idle/lock policy, desktop-shell bar layout and launchers,
media-server and torrent-client settings, VPN config, and any credentials.
The `.gitignore` is deny-by-default for that reason — new files have to be
opted in explicitly.
