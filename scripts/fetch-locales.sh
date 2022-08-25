#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# fetch-locales.sh: fetch and extract locales from arch glibc package
#
# a temporary workaround for typed locales on musl libc systems
# ----------------------------------------------------------------------------

set -eu

readonly DATADIR="${XDG_DATA_DIR:-$HOME/.local/share}/star"
readonly LOCALES="$DATADIR/locales"
readonly SOURCES="$DATADIR/sources"
readonly PKGNAME="glibc"
readonly VERSION=2.36
readonly RELEASE=3
readonly ARCH="x86_64"
# see: https://archlinux.org/mirrorlist
readonly MIRROR="https://mirror.aarnet.edu.au/pub/archlinux"
readonly REPO="core"
readonly BASENAME="$PKGNAME-$VERSION-$RELEASE-$ARCH.pkg.tar.zst"
readonly FILE="$SOURCES/$BASENAME"

clean() {
  if [[ -d "$DATADIR" ]]; then
    rm --recursive --force "$DATADIR"
  fi
}

ensure_requirements() {
  local executables_required
  local executables_missing

  executables_required=("curl" "gpg" "tar")
  executables_missing=()

  for executable in "${executables_required[@]}"; do
    if ! [[ $(command -v "$executable") ]]; then
      executables_missing+=("$executable")
    fi
  done

  if [[ ${#executables_missing[@]} -gt 0 ]]; then
    for executable in "${executables_missing[@]}"; do
      printf "Sorry, %s couldn't be found. Please install, then try again.\n" \
        "$executable"
    done
    exit 1
  fi
}

prepare() {
  mkdir --parents "$LOCALES"
  mkdir --parents "$SOURCES"
}

# fetch arch glibc package
fetch() {
  curl \
    --output-dir "$SOURCES" \
    --progress-bar \
    --remote-name-all \
    "$MIRROR/$REPO/os/$ARCH/$BASENAME"{,.sig}
}

# check arch glibc package signature
verify() {
  gpg \
    --keyserver-options auto-key-retrieve \
    --verify \
    "$FILE.sig"
}

# extract arch glibc locales into resources directory
extract() {
  tar \
    --zstd \
    --extract \
    --file="$FILE" \
    --directory="$LOCALES" \
    --strip-components=4 \
    usr/share/i18n/locales
}

main() {
  ensure_requirements
  clean
  prepare
  fetch
  verify
  extract
}

main
