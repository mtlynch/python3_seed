#!/bin/bash
# Downloads the latest copy of the line_length_linter plugin.

set -x

REMOTE_URL="https://raw.githubusercontent.com/mtlynch/line-length-linter/master/line_length_linter/line_length_lint.py"
OUTPUT_DIR=$(dirname "$0")
OUTPUT_FILE="${OUTPUT_DIR}/line_length_lint.py"

curl "$REMOTE_URL" > "$OUTPUT_FILE"
