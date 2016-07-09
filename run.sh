#!/usr/bin/sh

rm -r build
mkdir build
meson build
cd build
ninja-build
./src/valagtk
