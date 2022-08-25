#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# fetch-locales.sh: fetch and extract locales from arch glibc package
#
# a temporary workaround for typed locales on musl libc systems
# ----------------------------------------------------------------------------

set -eu

# shellcheck disable=SC2155
readonly STARDIR="$(dirname "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)")"
readonly RSRCDIR="$STARDIR/resources"
readonly PKGNAME="glibc"
readonly VERSION=2.36
readonly RELEASE=3
readonly ARCH="x86_64"
# see: https://archlinux.org/mirrorlist
readonly MIRROR="https://mirror.aarnet.edu.au/pub/archlinux"
readonly REPOSITORY="core"
readonly FILE="$PKGNAME-$VERSION-$RELEASE-$ARCH.pkg.tar.zst"

clean() {
  rm --force "$STARDIR/$FILE"{,.sig}
  if [[ -d "$RSRCDIR" ]]; then
    rm --recursive --force "$RSRCDIR"
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
  mkdir --parents "$RSRCDIR"
}

# fetch arch glibc package
fetch() {
  curl \
    --output-dir "$STARDIR" \
    --progress-bar \
    --remote-name-all \
    "$MIRROR/$REPOSITORY/os/$ARCH/$FILE"{,.sig}
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
    --directory="$RSRCDIR" \
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