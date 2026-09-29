# dotfiles

My Linux desktop configuration: **Fedora + Hyprland**, themed with **Everforest (Dark Medium)**.
Each folder in this repo is one self-contained component, so you can install only what you want.

> These are personal configs. Read a file before you use it, and back up your existing `~/.config` first.
---
## screenshots
<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/361105ab-2b00-4d8c-8f01-cb7511649959" />
<img width="1600" height="899" alt="image" src="https://github.com/user-attachments/assets/1f25a9fe-c04b-4dc1-b39a-ad1c06b58d0b" />
<img width="1600" height="900" alt="image" src="https://github.com/user-attachments/assets/b7b0c242-0d1c-47cf-8c6c-b2dc04b4b0db" />

---

## Overview

| Component | What it does | Folder |
|-----------|--------------|--------|
| Hyprland | Wayland tiling compositor (window manager) | `hypr/` |
| hyprlock | Lock screen, styled to match the theme | `hypr/` |
| hyprpaper | Wallpaper daemon for Hyprland | `hypr/` |
| Waybar | Status bar (workspaces, clock, system info) | `waybar/` |
| Wofi | Application launcher | `wofi/` |
| Dunst | Notification daemon | `dunst/` |
| Kitty | GPU-accelerated terminal emulator | `kitty/` |
| Yazi | Terminal file manager | `yazi/` |
| Neovim + LazyVim | Editor and plugin framework | `nvim/` |
| Everforest | Color scheme shared by every component | applied in each config |
| GNOME | Kept installed as a fallback session | not managed here |

---

## Repository layout

```text
dotfiles/
├── hypr/
│   └── .config/hypr/
│       ├── hyprland.conf
│       ├── hyprlock.conf
│       └── hyprpaper.conf
├── waybar/
│   └── .config/waybar/
│       ├── config.jsonc
│       └── style.css
├── wofi/
│   └── .config/wofi/
│       ├── config
│       └── style.css
├── dunst/
│   └── .config/dunst/
│       └── dunstrc
├── kitty/
│   └── .config/kitty/
│       └── kitty.conf
├── yazi/
│   └── .config/yazi/
│       ├── yazi.toml
│       ├── keymap.toml
│       └── theme.toml
├── nvim/
│   └── .config/nvim/
├── wallpaper/
│   └── just my wallpaper choice :)
└── README.md
```

Every top-level folder mirrors your home directory. Inside `hypr/`, the path `.config/hypr/hyprland.conf`
maps to `~/.config/hypr/hyprland.conf`. This layout is what lets GNU Stow install each component with one command.

---

## Installation

### 1. Install the packages

The command below installs the compositor, lock screen, wallpaper daemon, bar, launcher, notification daemon,
terminal, editor, and the symlink manager on Fedora. `git` fetches this repo, and `stow` (explained in step 3)
links the configs into place. Some Hyprland-related packages may live in a COPR repository depending on your
Fedora version, so check `dnf search hyprpaper` if a package is not found.

```bash
sudo dnf install hyprland hyprlock hyprpaper waybar wofi dunst kitty neovim git stow
```

Yazi is not always in the default Fedora repositories. If `dnf` cannot find it, install it from a COPR
repository or with Cargo (`cargo install --locked yazi-fm yazi-cli`), and follow the official Yazi
installation page for the current method.

### 2. Clone the repo

The repo goes in your home directory so the Stow commands in the next step work without extra flags.

```bash
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Link the configs with Stow

GNU Stow creates symlinks from your home directory to the files inside this repo. I recommend it over copying
files because editing `~/.config/hypr/hyprland.conf` then edits the tracked file directly, so the repo never
drifts out of sync with the live setup. Run it once per component you want.

```bash
stow hypr
stow waybar
stow wofi
stow dunst
stow kitty
stow yazi
stow nvim
```

If Stow reports a conflict, a real file already exists at that path. Move it aside (for example
`mv ~/.config/kitty ~/.config/kitty.bak`) and run the command again. Stow refuses to overwrite existing
files, which protects your current setup.

To remove a component later, `stow -D <folder>` deletes only the symlinks it created.

---

## Components

### Hyprland (`hypr/hyprland.conf`)

Hyprland is a dynamic tiling compositor for Wayland. It arranges windows automatically, animates them on the GPU,
and is configured through a single plain-text file. This file holds monitor layout, keybindings, window rules,
animations, and the startup applications.

- **Why Hyprland:** the whole desktop is defined in text, which makes it easy to version-control and share.
- **Reload:** changes apply live when the file is saved, so no logout is needed for most edits.
- **Nvidia note:** Nvidia GPUs on Wayland often need extra environment variables and driver setup. If Hyprland
  fails to start on an Nvidia card, check the Hyprland wiki's Nvidia page before debugging anything else.

### hyprlock (`hypr/hyprlock.conf`)

hyprlock is Hyprland's native lock screen. It replaces GNOME's default lock screen, which does not
integrate with a standalone Hyprland session. The config defines the background, the password input field,
and the clock, all colored with the Everforest Dark Medium palette so the lock screen matches the desktop.

- **Why a separate lock screen:** GNOME's lock screen depends on GNOME's session services, and hyprlock
  runs directly on Hyprland's own protocols.

### hyprpaper (`hypr/hyprpaper.conf`)

hyprpaper is a lightweight wallpaper daemon built for Hyprland. Wayland has no built-in way to draw a desktop
background, so a small program has to do it. The config lists which image to preload into memory and which
monitor to show it on.

- **Why hyprpaper:** it uses very little memory and reads a plain-text config that sits next to the rest of the Hyprland files.
- **Startup:** it runs at login through an `exec-once` line in `hyprland.conf`.
- **Your own wallpaper:** point the image path in the config at a file that exists on your machine, or nothing will be drawn.

### Waybar (`waybar/`)

Waybar is the status bar at the edge of the screen. It shows workspaces, the clock, and system information
such as battery, network, audio, and CPU or memory use.

- **`config.jsonc`** chooses which modules appear and where they sit (left, center, right).
- **`style.css`** controls how the bar looks, using ordinary CSS with the Everforest colors.
- **Why split into two files:** layout and appearance change for different reasons, so you can restyle the bar without touching its behavior.
- **Startup:** launched from `hyprland.conf` with `exec-once`. After editing, restart it (`pkill waybar && waybar &`) to see the change.

### Wofi (`wofi/`)

Wofi is a Wayland application launcher. A keybinding in `hyprland.conf` opens a searchable list of installed
apps, and typing filters it.

- **`config`** sets behavior such as the mode, window size, and number of visible entries.
- **`style.css`** styles the window with the same palette as the rest of the setup.
- **Why a launcher:** in a tiling setup there is no application menu, so the launcher is the fastest way to start programs.

### Dunst (`dunst/dunstrc`)

Dunst is a notification daemon. Applications send desktop notifications over D-Bus, and Dunst is the program
that draws them on screen. Without a daemon running, those notifications are silently dropped.

- **`dunstrc`** holds the position, size, font, timeout, and colors, with separate sections for low, normal, and critical urgency.
- **Startup:** launched from `hyprland.conf` with `exec-once`.
- **Test it:** `notify-send "Hello" "Dunst is working"` should show a popup.

### Kitty (`kitty/kitty.conf`)

Kitty is a terminal emulator that renders text on the GPU. The config sets the font, padding, opacity,
and the Everforest colors for the 16 ANSI terminal colors plus background and foreground.

- **Why Kitty:** it is fast, supports ligatures and inline images, and has a simple text-based config.

### Yazi (`yazi/`)

Yazi is a terminal file manager written in Rust. It browses directories with keyboard navigation, previews
files in a side pane, and runs tasks asynchronously so large folders do not freeze the interface.

- **`yazi.toml`** holds general behavior, such as which programs open which file types.
- **`keymap.toml`** holds custom keybindings.
- **`theme.toml`** holds the Everforest colors for the interface.
- **Why Yazi:** it keeps file management inside the terminal, and Kitty's image support lets it show previews of images.
- **Image previews** depend on the terminal, so they work best inside Kitty.

### Neovim + LazyVim (`nvim/`)

Neovim is a modal terminal editor. LazyVim is a preconfigured setup built on the `lazy.nvim` plugin manager,
which loads plugins on demand so startup stays fast. Language servers, fuzzy finding, a file tree, and a
statusline come ready to use.

- **Custom plugins** go in `lua/plugins/`. Each file returns a table describing one or more plugins,
  which LazyVim merges with its defaults.
- **First launch:** open `nvim` once and wait. `lazy.nvim` downloads every plugin automatically.
- **AI integration:** this config also includes a Claude Code plugin for Neovim. <!-- TODO: name the plugin and link it -->

### Everforest theme (Dark Medium)

Everforest is a low-contrast, green-tinted palette designed to reduce eye strain. I use the **Dark Medium**
variant rather than Hard because its background is slightly lighter, which is more comfortable for long
late-night sessions. Using one palette everywhere (compositor borders, lock screen, bar, launcher, notifications,
terminal, file manager, editor) is what makes the desktop look unified.

Core colors used across the configs:

| Role | Hex |
|------|-----|
| Background | `#2d353b` |
| Foreground | `#d3c6aa` |
| Green (accent) | `#a7c080` |
| Aqua | `#83c092` |
| Blue | `#7fbbb3` |
| Yellow | `#dbbc7f` |
| Orange | `#e69875` |
| Red | `#e67e80` |
| Purple | `#d699b6` |

### GNOME fallback session

GNOME stays installed permanently. If a Hyprland update breaks the session, choose **GNOME** from the gear icon
on the login screen (GDM) to get a working desktop and fix the config from there. Nothing in this repo modifies GNOME.

---

## Usage tips

- Log out, pick **Hyprland** at the login screen, and sign back in to start the session.
- Read `hyprland.conf` first. The keybindings section tells you how to open a terminal, launch apps, and close windows.
- Change the colors in one place at a time and reload, so a typo is easy to trace.

---

## Troubleshooting

| Symptom | Likely cause |
|---------|--------------|
| Black screen after login | Missing GPU driver or Wayland environment variables |
| `stow` reports a conflict | A real config already exists at the target path |
| Neovim shows plugin errors | First-launch plugin install has not finished, so restart `nvim` |
| Lock screen shows default colors | `hyprlock.conf` was not linked, so re-run `stow hypr` |
| No wallpaper | hyprpaper is not running, or the image path in `hyprpaper.conf` does not exist |
| No bar at the top or bottom | Waybar is not running, so start it manually and read its error output |
| Notifications never appear | Dunst is not running, so check the `exec-once` line in `hyprland.conf` |
| Launcher keybinding does nothing | Wofi is not installed, or the bind in `hyprland.conf` points to a wrong command |

---

## Credits

- [Hyprland](https://hyprland.org/)
- [hyprpaper](https://github.com/hyprwm/hyprpaper)
- [Waybar](https://github.com/Alexays/Waybar)
- [Wofi](https://hg.sr.ht/~scoopta/wofi)
- [Dunst](https://dunst-project.org/)
- [Kitty](https://sw.kovidgoyal.net/kitty/)
- [Yazi](https://yazi-rs.github.io/)
- [LazyVim](https://www.lazyvim.org/)
- [Everforest](https://github.com/sainnhe/everforest) by sainnhe

## License

MIT, so feel free to copy, modify, and share.
