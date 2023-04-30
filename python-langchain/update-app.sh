#!/usr/bin/env zsh
#
# The main script to push to github
#
# See README.md for instructions
#
# abort on errors
set -e

./update-langchain-local-env.sh
./sign-libraries.sh 
./copy-libraries-to-bundle-folder.sh 
