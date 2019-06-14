#!/bin/bash

SYSROOT=$ANDROID_NDK_DIR/platforms/$TARGET_PLATFORM/arch-arm64/
TOOLCHAIN=$ANDROID_NDK_DIR/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

# From doc (https://developer.android.com/ndk/guides/abis.html#v7a)
# The instruction extensions that this Android-specific ABI supports are:
# (1) The Thumb-2 instruction set extension, which provides performance comparable to 32-bit ARM instructions with similar compactness to Thumb-1.
#        ---> --arch=arm --extra-cflags="-Os -fpic -marm $ADDI_CFLAGS"
# (2) VFPv3-D16, which includes 16 dedicated 64-bit floating point registers, in addition to another 16 32-bit registers from the ARM core.
#        ---> --arch=arm --extra-cflags="-Os -fpic -marm -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 $ADDI_CFLAGS"

function build_ffmpeg
{
    ./configure --prefix=$FFMPEG_PREFIX $FFMPEG_COMMON_FLAGS --cross-prefix=$TOOLCHAIN/bin/aarch64-linux-android- \
            --target-os=linux --arch=aarch64 --enable-cross-compile --sysroot=$SYSROOT \
            --extra-cflags="-O3 -fpic -DANDROID -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing $ADDI_CFLAGS" \
            --extra-ldflags="-Wl,-rpath-link=$SYSROOT/usr/lib -L$SYSROOT/usr/lib -nostdlib -lc -lm -ldl -llog $ADDI_LDFLAGS"

    make clean
    make -j2
    make install
}

export CPU=arm64-v8a
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

if [ "$USE_STATIC_FFMPEG_LIBS" = true ]; then
    cp Android_prebuilt_static.mk $FFMPEG_PREFIX/Android.mk
    cd ..
    cp Android_static.mk $JNI_DIR/Android.mk
else
    cp Android_prebuilt_shared.mk $FFMPEG_PREFIX/Android.mk
    cd ..
    cp Android_shared.mk $JNI_DIR/Android.mk
fi

cd $JNI_DIR
export ABI=$CPU
printf "\nStarting ndk-build...\n\n"
ndk-build clean
ndk-build
