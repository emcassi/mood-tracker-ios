#!/bin/zsh

python3 -m venv .venv || { echo "Failed to create virtual environment"; exit 1; }

source .venv/bin/activate || { echo "Failed to activate virtual environment"; deactivate; exit 1; }

pip install -r py_reqs.txt || { echo "Failed to install requirements"; deactivate; exit 1; }

python3 make_hotlines_db.py || { echo "Failed to run script"; deactivate; exit 1; }

deactivate

