#!/bin/sh
# Install script for Eliane

echo "Installing Eliane to dust/code/eliane"
INSTALL_DIR=~/dust/code/eliane
mkdir -p $INSTALL_DIR

cp *.lua $INSTALL_DIR/
cp *.sc $INSTALL_DIR/
cp manifest.lua $INSTALL_DIR/
cp presets.lua $INSTALL_DIR/

mkdir -p $INSTALL_DIR/docs
cp docs/*.png $INSTALL_DIR/docs/

echo "Installation complete. Reload scripts in Norns."
