#!/bin/bash

find . -type f -name "*.c" -exec dos2unix {} \;
find . -type f -name "*.c" -exec sed -i 's/\t/    /g' {} \;
find . -type f -name "*.h" -exec dos2unix {} \;
find . -type f -name "*.h" -exec sed -i 's/\t/    /g' {} \;
find . -type f -name "Makefile" -exec dos2unix {} \;
