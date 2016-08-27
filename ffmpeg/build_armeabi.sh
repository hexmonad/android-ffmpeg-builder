#!/bin/bash

SYSROOT=$ANDROID_NDK_DIR/platforms/$TARGET_PLATFORM/arch-arm/
TOOLCHAIN=$ANDROID_NDK_DIR/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

function build_ffmpeg
{
    ./configure $FFMPEG_COMMON_FLAGS --prefix=$FFMPEG_PREFIX --sysroot=$SYSROOT --target-os=linux \
            --cross-prefix=$TOOLCHAIN/bin/arm-linux-androideabi- \
            --cpu=armv5te --arch=arm --disable-asm --enable-armv5te --disable-stripping \
            --extra-cflags="-O3 -Wall -pipe -std=c99 -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack -DANDROID -DNDEBUG-march=armv5te -mtune=arm9tdmi -msoft-float $ADDI_CFLAGS" \
            --extra-ldflags="$ADDI_LDFLAGS" 

    make clean
    make -j2 
    make install
}

export CPU=armeabi
export FFMPEG_PREFIX=$FFMPEG_DIR/android-build/$CPU

# Update ffmpeg configure file
cd ./ffmpeg
python FFmpegConfigureParser.py -i $FFMPEG_DIR

cd $FFMPEG_DIR
printf "\nStart FFmpeg build process...\n"
build_ffmpeg
printf "\nFFmpeg build process is finished.\n"

# Copy files to jni folder which are needed to build FfmpegExecutor NDK module.
# You can skip this step if these files are already generated.
cd ..
python FFmpegParser.py -p $FFMPEG_DIR -d $JNI_DIR
cp Android_shared.mk $FFMPEG_PREFIX/Android.mk

cd $JNI_DIR
export ABI=$CPU
printf "\nStarting ndk-build...\n\n"
ndk-build clean
ndk-build
