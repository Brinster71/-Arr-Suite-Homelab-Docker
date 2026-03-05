#!/usr/bin/env bash
set -euo pipefail

# Bootstrap build tooling for Python and Debian package source builds on Ubuntu.
# Usage:
#   bash scripts/setup-build-env.sh [--skip-venv] [--venv-path <path>]

usage() {
  cat <<'USAGE'
Usage: bash scripts/setup-build-env.sh [--skip-venv] [--venv-path <path>]

Options:
  --skip-venv         Skip creating a Python virtual environment.
  --venv-path <path>  Virtual environment path (default: .venv).
  -h, --help          Show this help message.
USAGE
}

SKIP_VENV=0
VENV_PATH=".venv"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --skip-venv)
      SKIP_VENV=1
      shift
      ;;
    --venv-path)
      if [[ $# -lt 2 || -z "${2:-}" ]]; then
        echo "Error: --venv-path requires a path value." >&2
        exit 1
      fi
      VENV_PATH="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: unknown argument '$1'." >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -r /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  if [[ "${ID:-}" != "ubuntu" ]]; then
    echo "Warning: this script targets Ubuntu. Detected '${ID:-unknown}'. Continuing..." >&2
  fi
fi

SUDO=""
if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  SUDO="sudo"
fi

# Start with the exact requested package set.
$SUDO apt update
$SUDO apt install -y \
  build-essential \
  python3 python3-dev python3-venv python3-pip \
  pkg-config \
  libffi-dev libssl-dev \
  debhelper devscripts dh-python fakeroot lintian

# Common extras for apt/deb source build workflows.
$SUDO apt install -y dpkg-dev equivs

if [[ "$SKIP_VENV" -eq 0 ]]; then
  python3 -m venv "$VENV_PATH"
  # shellcheck disable=SC1090
  source "$VENV_PATH/bin/activate"
  python -m pip install --upgrade pip setuptools wheel build
  deactivate
fi

echo "Done."
