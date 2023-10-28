# Python3 Seed

[![CircleCI](https://circleci.com/gh/mtlynch/python3_seed.svg?style=svg)](https://circleci.com/gh/mtlynch/python3_seed)
[![License](https://img.shields.io/badge/license-Unlicense-blue)](LICENSE)

## Overview

A boilerplate Python 3 project set up for unit tests and continuous integration.

Specifically:

* Enforces Python style rules with [YAPF](https://github.com/google/yapf)
* Performs static analysis with [pyflakes](https://github.com/megies/pyflakes) and [pylint](https://github.com/PyCQA/pylint)
* Sorts imports with [isort](https://github.com/timothycrosley/isort)

## Installation

```bash
mkdir -p ./venv && \
  virtualenv --python python3 ./venv && \
  . venv/bin/activate && \
  pip install --requirement dev_requirements.txt && \
  ./dev-scripts/enable-git-hooks
```

## Customization

To customize this for your project:

1. Change `LICENSE` to [a license of your choosing](https://choosealicense.com/).
1. Change the CircleCI badge in `README.md` to your own Circle CI project badge.
1. Change the app name in `main.py` from `Python Seed` to your app's name.
1. Rename `app/dummy.py` and `app/dummy_test.py` to the module names of your choosing.
1. Begin working.

## Run

```bash
./main.py
```
