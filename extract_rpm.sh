#!/bin/bash

# Extracts the contents of a RPM package in the current directory
# Iván Chavero <ichavero@chavero.com.mx>

echo "Extracting $1"
rpm2cpio $1 | cpio -idmv
