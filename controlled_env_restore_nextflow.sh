#!/usr/bin/env bash
set -euo pipefail

# Restore portable Nextflow bundle into a controlled environment (no sudo required).
# Source repo: https://github.com/Tim-Yu/portable-nextflow-3.2
#
# Usage:
#   bash controlled_env_restore_nextflow.sh
#   ROOT_DIR=/re_gecip/cancer_sarcoma/36.Oncoanalyser_CCS_GMScases/36.1.workflow \
#     bash controlled_env_restore_nextflow.sh
#   TARGET_DIR=/re_gecip/cancer_sarcoma/36.Oncoanalyser_CCS_GMScases/36.1.workflow/3.2.Nextflow \
#     bash controlled_env_restore_nextflow.sh

ROOT_DIR="${ROOT_DIR:-/re_gecip/cancer_sarcoma/36.Oncoanalyser_CCS_GMScases/36.1.workflow}"
TARGET_DIR="${TARGET_DIR:-$ROOT_DIR/3.2.Nextflow}"
BRANCH="${BRANCH:-main}"

BASE_URL="https://github.com/Tim-Yu/portable-nextflow-3.2/raw/refs/heads/${BRANCH}"

NEXTFLOW_URL="${BASE_URL}/bin/nextflow"
RUN_HELPER_URL="${BASE_URL}/run_nextflow.sh"
JAR_URL="${BASE_URL}/share/nextflow/dist/25.04.2/nextflow-25.04.2-one.jar"

mkdir -p "$TARGET_DIR/bin"
mkdir -p "$TARGET_DIR/share/nextflow/dist/25.04.2"
mkdir -p "$TARGET_DIR/.nextflow"

fetch() {
  local url="$1"
  local out="$2"
  echo "Downloading: $url"
  curl -fL --retry 5 --retry-delay 2 --retry-all-errors "$url" -o "$out"
}

fetch "$NEXTFLOW_URL" "$TARGET_DIR/bin/nextflow"
fetch "$RUN_HELPER_URL" "$TARGET_DIR/run_nextflow.sh"
fetch "$JAR_URL" "$TARGET_DIR/share/nextflow/dist/25.04.2/nextflow-25.04.2-one.jar"

chmod +x "$TARGET_DIR/bin/nextflow" "$TARGET_DIR/run_nextflow.sh"

# Force local cache path for predictable controlled-env behavior.
export NXF_HOME="${NXF_HOME:-$TARGET_DIR/.nextflow}"

if command -v java >/dev/null 2>&1; then
  echo
  "$TARGET_DIR/run_nextflow.sh" -version
else
  echo
  echo "[WARN] Java is not available in the current shell (java: command not found)."
  echo "[WARN] Restore completed, but version check was skipped."
  echo "[INFO] Load a module that provides Java before running Nextflow."
  echo "[INFO] Example: module load nextflow/24.04.2-with-plugins"
fi

echo
printf 'Restore complete. Portable Nextflow is available at: %s\n' "$TARGET_DIR"
printf 'Use in HPC scripts with: export NEXTFLOW_BIN=%s\n' "$TARGET_DIR/bin/nextflow"
