#!/usr/bin/env zsh
#
# The main script to push to github
#
# See README.md for instructions
#
# abort on errors
set -e

codesign -s "Developer ID Application: Alexis Rondeau (HKQARCV8QZ)" -f ./**/*.so
codesign -s "Developer ID Application: Alexis Rondeau (HKQARCV8QZ)" -f ./env/lib/python3.11/site-packages/numpy/.dylibs/*.dylib
