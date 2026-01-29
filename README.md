# bluedot

Fedora Silverblue derivative image for my computers. Downstream of [ublue-os/main](https://github.com/ublue-os/main).

My goal is to keep my base system and home folder clean while making it more intuitive to spin up sandboxes and containers for development. This means we avoid global package pollution as much as possible (as well as weird collisions in the global, version-specific gemfolder and node_modules folders nvm and rbenv install in $HOME); though of course complex projects will have their own containers on top of this anyway. The trouble is also that we have *a lot* of solutions for environment hygiene (see also: the Python ecosystem) but layering the entire OS around it elegantly, composably (without pure Nix madness) takes some intentionality.

## Main configuration

- Adds Tailscale to the Silverblue image along with git, vim, and some GNOME shell extensions (Blur My Shell, Caffeine)
- Preinstalls Flatpaks I regularly use (Steam, Itch, Firefox, VLC, Audacity, Discord, Zed, Obsidian, Mumble)
- Homebrew bundle of CLI apps + fonts (Senpai IRC client; Ubuntu + M PLUS Code fonts)
- Some Justfile scripts for bootstrapping my dev containers (Ruby + Node distroboxes isolated from `$HOME` but exporting their binaries to the base system)

## TODO

- Firefox configuration (remove bookmarks, set flags to remove sponsored sites, telemetry, AI sidebars, add UBlock and Kagi)
- Add "Logo Menu" extension to the build
