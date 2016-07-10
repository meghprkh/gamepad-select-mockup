#!/usr/bin/sh

if [ ! -z $1 ]; then
  rm -r build
fi

if ! [ -d build ]; then
  mkdir build
  meson build
fi

cd build && ninja-build && ./src/valagtk
