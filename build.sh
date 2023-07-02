#!/bin/bash

set -e

# Make a copy so we never alter the original
cp -r /pkg /tmp/pkg
cd /tmp/pkg
updpkgsums

# Do the actual building. Paru will fetch all dependencies for us (including
# AUR dependencies) and then build the package.
sudo pacman -Syu --noconfirm
MAKEFLAGS="-j $(nproc)" paru -U --noconfirm

makepkg --printsrcinfo > .SRCINFO
sudo chown "$(stat -c '%u:%g' /pkg/PKGBUILD)" ./.SRCINFO
sudo mv ./.SRCINFO /pkg
sudo mv ./PKGBUILD /pkg
