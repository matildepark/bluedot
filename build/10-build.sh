#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Main Build Script
###############################################################################
# This script follows the @ublue-os/bluefin pattern for build scripts.
# It uses set -eoux pipefail for strict error handling and debugging.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Copy Custom Files"

# Copy Brewfiles to standard location
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom/brew/*.Brewfile /usr/share/ublue-os/homebrew/

# Consolidate Just Files
mkdir -p /usr/share/ublue-os/just/
find /ctx/custom/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just

# Copy Flatpak preinstall files
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

echo "::endgroup::"

echo "::group:: Install Packages"

# Install packages using dnf5
dnf5 install -y git bootc make gcc fastfetch gnome-tweaks mesa-libGLU screen vim samba gnome-shell-extension-caffeine gnome-shell-extension-blur-my-shell
dnf5 -y remove firefox fedora-bookmarks gnome-extensions-app firefox-langpacks fedora-chromium-config fedora-chromium-config-gnome gnome-shell-extension-background-logo

# Tailscale
dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf config-manager setopt tailscale-stable.enabled=0
dnf -y install --enablerepo='tailscale-stable' tailscale

# Bluefin patches fwupd, so I guess I will too
dnf -y copr enable ublue-os/staging
dnf -y copr disable ublue-os/staging
dnf -y swap \
    --repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    fwupd fwupd

echo "::endgroup::"

echo "::group:: System Configuration"

# Enable/disable systemd services
systemctl enable podman.socket
systemctl enable tailscaled.service
# Example: systemctl mask unwanted-service

echo "::endgroup::"

echo "Custom build complete!"
