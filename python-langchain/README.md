## Steps taken to create a first distribution

```bash
# Created environment
$ python3 -m venv env

# Activate environment
$ source env/bin/activate

# Check version
$ which python
;; Python 3.11.2

# Install requirements.txt deps
$ python -m pip install -r requirements.txt

# Sign .so files
$ codesign -s "Developer ID Application: Alexis Rondeau (HKQARCV8QZ)" -f ./**/*.so

# Sign .dylib files
$ codesign -s "Developer ID Application: Alexis Rondeau (HKQARCV8QZ)" -f ./env/lib/python3.11/site-packages/numpy/.dylibs/*.dylib

# Copy libs to distribution folder


```
