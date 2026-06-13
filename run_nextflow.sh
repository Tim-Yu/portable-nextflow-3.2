#!/usr/bin/env bash
set -euo pipefail
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export NXF_HOME="${NXF_HOME:-$BASE_DIR/.nextflow}"
exec "$BASE_DIR/bin/nextflow" "$@"
