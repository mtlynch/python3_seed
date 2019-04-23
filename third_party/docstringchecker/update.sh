#!/bin/bash
# Downloads the latest copy of the DocStringChecker plugin.

# Exit build script on first failure.
set -e

# Echo commands to stdout.
set -x

# Treat undefined variables as errors.
set -u

OUTPUT_DIR=$(dirname "$0")
OUTPUT_FILE="${OUTPUT_DIR}/lint.py"

wget \
  https://chromium.googlesource.com/chromiumos/chromite/+/master/cli/cros/lint.py?format=TEXT \
  -O - | \
  base64 --decode \
  > "$OUTPUT_FILE"
