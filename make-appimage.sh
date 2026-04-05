#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q lightzone | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/256x256/apps/lightzone.png
export DESKTOP=/usr/share/applications/lightzone.desktop
export DEPLOY_P11KIT=1
export DEPLOY_COMMON_LIBS=1

# Deploy dependencies
quick-sharun \
	/usr/bin/lightzone \
	/usr/lib/lightzone \
	/usr/bin/dcraw_lz  \
	/usr/bin/java      \
	/usr/share/java    \
	/usr/lib/jvm/java-26-openjdk

sed -i -e 's|usrdir=/usr|usrdir=$APPDIR|' ./AppDir/bin/lightzone

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
