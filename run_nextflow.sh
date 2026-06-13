#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Force local cache path for controlled environments where inherited NXF_HOME
# may point to non-writable home directories.
export HOME="$BASE_DIR"
export NXF_HOME="$BASE_DIR/.nextflow"
export CAPSULE_CACHE_DIR="$NXF_HOME/capsule"
export NXF_TEMP="$NXF_HOME/tmp"
mkdir -p "$NXF_HOME" "$CAPSULE_CACHE_DIR" "$NXF_TEMP"
exec "$BASE_DIR/bin/nextflow" "$@"
