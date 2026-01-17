# bluedot

Fedora Silverblue derivative image for my computers. Downstream of [ublue-os/main](https://github.com/ublue-os/main).

## Main configuration

- Adds Tailscale to the Silverblue image along with git, vim, and some GNOME shell extensions (Blur My Shell, Caffeine)
- Preinstalls Flatpaks I regularly use (Steam, Itch, Firefox, VLC, Audacity, Discord, Zed, Obsidian, Mumble)
- Homebrew bundle of CLI apps + fonts (Senpai IRC client; Ubuntu + M PLUS Code fonts)
- Some Justfile scripts for bootstrapping my dev containers (Ruby + Node distroboxes isolated from `$HOME` but exporting their binaries to the base system)


## TODO

- Firefox config? 
-
