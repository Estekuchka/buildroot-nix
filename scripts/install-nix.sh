#!/bin/sh
#
# Buildroot + Nix
# install-nix.sh
#
# Installs the Nix package manager on a Buildroot system.
#

set -e

########################################
# Check permissions
########################################

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: this script must be run as root."
    exit 1
fi

########################################
# Variables
########################################

NIX_BUILD_USERS=10

echo "====================================="
echo " Buildroot + Nix Installer"
echo "====================================="
echo

########################################
# Step 1 - Prepare the environment
########################################

echo "[1/4] Preparing environment..."

mkdir -p -m 755 /nix
chown root:root /nix

# Use /root/tmp as temporary directory
mkdir -p /root/tmp
export TMPDIR=/root/tmp

########################################
# Step 2 - Create nix users
########################################

echo "[2/4] Creating nixbld group and users..."

if ! getent group nixbld >/dev/null; then
    groupadd nixbld
fi

# Create build users required by Nix
for i in $(seq 1 $NIX_BUILD_USERS); do
    useradd -g nixbld -M -N -r -s /bin/false nixbld$i
done

# Add users to nixbld group
for i in $(seq 1 $NIX_BUILD_USERS); do
    usermod -aG nixbld nixbld$i
done

########################################
# Step 3 - Install Nix
########################################

echo "[3/4] Installing Nix..."

curl -L https://nixos.org/nix/install -o install-nix
chmod +x install-nix

sh install-nix --no-daemon

########################################
# Step 4 - Verify installation
########################################

echo "[4/4] Verifying installation..."

. /root/.nix-profile/etc/profile.d/nix.sh

nix --version

########################################
# Cleanup
########################################

rm -f install-nix

echo
echo "====================================="
echo " Nix installed successfully!"
echo "====================================="
echo
echo "If needed, load the Nix environment with:"
echo
echo "    . /root/.nix-profile/etc/profile.d/nix.sh"
echo
