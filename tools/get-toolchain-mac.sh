#!/bin/bash

# Function to check if a package is installed
is_package_installed() {
    brew list $1 &>/dev/null
}

# Function to check if Homebrew is installed
is_homebrew_installed() {
    command -v brew &>/dev/null
}

# List of packages to check and install
packages="wget gcc-arm-none-eabi ninja cmake"

# Check if Homebrew is installed
if ! is_homebrew_installed; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if ! is_homebrew_installed; then
        echo "Homebrew installation failed. Please install it manually and re-run this script."
        exit 1
    fi
else
    echo "Homebrew is already installed."
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

all_installed=true

for package in $packages; do
    if ! is_package_installed $package; then
        all_installed=false
        break
    fi
done

if $all_installed; then
    echo "All required packages are already installed."
    exit 0
fi

echo "Installing missing packages..."

for package in $packages; do
    if ! is_package_installed $package; then
        echo "Installing $package..."
        brew install $package
    fi
done

echo "All required packages are now installed."
