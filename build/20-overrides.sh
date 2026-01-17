#!/usr/bin/bash

set -eoux pipefail

# Porting some overrides from Bluefin we probably want too.
rm -rf /usr/src
rm -rf /usr/share/doc
rpm --erase --nodeps kernel-devel
## Since we use a different system monitor and it might preinstall the desktop file:
if [[ -f /usr/share/applications/gnome-system-monitor.desktop ]]; then
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/gnome-system-monitor.desktop
fi
if [[ -f /usr/share/applications/org.gnome.SystemMonitor.desktop ]]; then
    sed -i 's@\[Desktop Entry\]@\[Desktop Entry\]\nHidden=true@g' /usr/share/applications/org.gnome.SystemMonitor.desktop
fi

flatpak remote-add --system --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
systemctl disable flatpak-add-fedora-repos.service

systemctl enable uupd.timer
