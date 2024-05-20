#!/usr/bin/env bash
# A rebuild script that commits on a successful build
set -e

# cd to your config dir
pushd ~/dotfiles/nixos/

# show in editor
nano configuration.nix

# Autoformat your nix files
# nix fmt *.nix

# Shows your changes
git diff -U0 *.nix

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo cp configuration.nix /etc/nixos/configuration.nix
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)

# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available

# Commit all changes witih the generation metadata
git commit -am "$current"
git push

# Back to where you were
popd

