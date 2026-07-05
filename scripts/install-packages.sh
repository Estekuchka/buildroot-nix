#!/bin/sh

set -e

# Using the old Nix syntax for better compatibility with version 2.34
nix-env -iA nixpkgs.fastfetch
nix-env -iA nixpkgs.nano
nix-env -iA nixpkgs.htop
