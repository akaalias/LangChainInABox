#!/usr/bin/env zsh
#
# The main script to push to github
#
# See README.md for instructions
#
# abort on errors
set -e

source env/bin/activate
python -m pip install --upgrade -r requirements.txt
