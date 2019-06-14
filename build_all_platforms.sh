#!/bin/bash

# Please setup a path to Android NDK below manually
export ANDROID_NDK_DIR=
# Minimum platform version for arm64 is 21
export TARGET_PLATFORM=android-21

export PATH="$PATH:$ANDROID_NDK_DIR"

export FFMPEG_DIR="$(pwd)/ffmpeg/FFmpeg"
export JNI_DIR="$(pwd)/jni"
export JNI_LIBS="$(pwd)/jni/jniLibs"

export FFMPEG_COMMON_FLAGS="--disable-programs --disable-doc --disable-linux-perf --enable-shared --enable-static --enable-protocol=file"

# If USE_STATIC_FFMPEG_LIBS = true, this script generates a single shared library which consist of static ffmpeg libraries and a library to run ffmpeg commands.
# Otherwise, the script generates a set of shared libraries.
export USE_STATIC_FFMPEG_LIBS=false

# run build scripts for each platform
# if you don't want to build a library for particular platform, just comment out the corresponding line

#./ffmpeg/build_armeabi-v7a.sh
./ffmpeg/build_arm64-v8a.sh