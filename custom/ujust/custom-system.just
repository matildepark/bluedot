# vim: set ft=make :
#######################
### custom-system.just
#######################
## Example system configuration commands
## These are simplified examples adapted from Bluefin

# Configure docker and libvirt groups for development
[group('System')]
configure-dev-groups:
    #!/usr/bin/pkexec bash
    CURRENT_USER="{{ `id -un` }}"
    echo "Adding $CURRENT_USER to docker and libvirt groups..."

    # Ensure groups exist in /etc/group
    for group in docker libvirt; do
        if ! grep -q "^$group:" /etc/group; then
            echo "Adding $group to /etc/group"
            grep "^$group:" /usr/lib/group | tee -a /etc/group > /dev/null
        fi
        usermod -aG $group $CURRENT_USER
    done

    echo "Groups configured. Log out and back in for changes to take effect."

# Clean up container images and volumes
[group('Maintenance')]
clean-containers:
    #!/usr/bin/bash
    echo "Cleaning up Podman containers, images, and volumes..."
    podman system prune -af
    podman volume prune -f
    echo "Cleanup complete!"

# Update system and reboot if needed
[group('Maintenance')]
update-and-reboot:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    echo "Updating system..."
    sudo bootc upgrade
    if gum confirm "Reboot now to apply updates?"; then
        systemctl reboot
    else
        echo "Reboot later to apply updates."
    fi

[group('distrobox')]
distrobox-create-node-dev:
    #!/usr/bin/bash
    echo "Creating node-dev distrobox container..."
    distrobox create --name node-dev --image fedora:latest \
      --home ~/.local/share/distrobox/node-dev \
      --volume $HOME/git:/git:rslave \
      --volume $HOME/.ssh:$HOME/.ssh:ro \
      --volume $HOME/.gitconfig:$HOME/.gitconfig:ro
    echo "Container created successfully!"

[group('distrobox')]
distrobox-setup-node-dev:
    #!/usr/bin/bash
    echo "Setting up NVM and Node.js in node-dev container..."
    distrobox enter node-dev -- bash -c '
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install 24
        distrobox-export --bin $(which node)
        distrobox-export --bin $(which npm)
    '

[group('distrobox')]
setup-node-devenv:
    #!/usr/bin/bash
    echo "Bootstrapping node-dev container..."
    just distrobox-create-node-dev
    just distrobox-setup-node-dev
    echo "Bootstrap complete!"

[group('distrobox')]
distrobox-create-ruby-dev:
    #!/usr/bin/bash
    echo "Creating ruby-dev distrobox container..."
    distrobox create --name ruby-dev --image fedora:latest \
        --home ~/.local/share/distrobox/ruby-dev \
        --volume $HOME/git:/git:rslave \
        --volume $HOME/.ssh:$HOME/.ssh:ro \
        --volume $HOME/.gitconfig:$HOME/.gitconfig:ro
    echo "Container created successfully!"

[group('distrobox')]
distrobox-setup-ruby-dev:
    #!/usr/bin/bash
    echo "Setting up rbenv..."
    distrobox enter ruby-dev -- bash -c '
        sudo dnf install rbenv ruby-build
        rbenv install 3.4.8 && rbenv global 3.4.8
        distrobox-export --bin $(which ruby)
    '

[group('distrobox')]
setup-ruby-devenv:
    #!/usr/bin/bash
    echo "Bootstrapping ruby-dev container..."
    just distrobox-create-ruby-dev
    just distrobox-setup-ruby-dev
    echo "Bootstrap complete!"

[group('distrobox')]
setup-devenvs:
    #!/usr/bin/bash
    echo 'Bootstrapping dev envs...'
    just setup-node-devenv
    just setup-ruby-devenv
    echo 'All bootstraps complete.'
