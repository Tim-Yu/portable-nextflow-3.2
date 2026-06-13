#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Force local cache path for controlled environments where inherited NXF_HOME
# may point to non-writable home directories.
export NXF_HOME="$BASE_DIR/.nextflow"
exec "$BASE_DIR/bin/nextflow" "$@"
