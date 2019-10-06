# Python3 Seed

[![CircleCI](https://circleci.com/gh/mtlynch/python3_seed.svg?style=svg)](https://circleci.com/gh/mtlynch/python3_seed) [![Coverage Status](https://coveralls.io/repos/github/mtlynch/python3_seed/badge.svg?branch=master)](https://coveralls.io/github/mtlynch/python3_seed?branch=master)

## Overview

A boilerplate Python 3 project set up for unit tests and continuous integration.

Specifically:

* Enforces Python style rules with [YAPF](https://github.com/google/yapf)
* Enforces style rules on docstrings using [DocStringChecker](https://chromium.googlesource.com/chromiumos/chromite/+/master/cli/cros/lint.py)
* Perfoms static analysis with [pyflakes](https://github.com/megies/pyflakes)
* Sorts imports with [isort](https://github.com/timothycrosley/isort)
