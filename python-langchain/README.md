# This is the update workshop
This is where I update langchain and copy over the new libraries to $ROOT/langchain-libraries

## Update $ROOT/langchain-libraries
### Run Script
```bash
$ ./update-langchain.sh
```

### Clean Build in XCode
```
Command-Shift-K
```

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
