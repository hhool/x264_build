#!/bin/bash
if [ -z ${NDK_ROOT} ]
then
NDK_ROOT=/opt/env/android-ndk-r22
fi

HOST_OS="linux"
if [[ $(uname) == "Darwin" ]]
then
 HOST_OS="darwin"
fi

TOOLCHAIN=${NDK_ROOT}/toolchains/llvm/prebuilt/${HOST_OS}-x86_64

echo "HOST_OS:"${HOST_OS}
echo "TOOLCHAIN:"${TOOLCHAIN}

if [ ! -d ${TOOLCHAIN} ]
then
  echo "wrong:"${NDK_ROOT}
  exit 1;
fi

API=22

function x264_build
{
mkdir android_build
pushd android_build
echo "CC:"${CC}
echo "CXX:"${CXX}
echo "ADDITIONAL_CONFIGURE_FLAG:"${ADDITIONAL_CONFIGURE_FLAG}
../src/configure --prefix=$PREFIX \
--extra-cflags=${EXTRA_CFLAGS} \
--host=${HOST} \
--cross-prefix=${CROSS_PREFIX} \
--sysroot=${TOOLCHAIN}/sysroot \
${ADDITIONAL_CONFIGURE_FLAG} \
--disable-cli --enable-shared --enable-static --enable-pic
make clean
make -j8
make install
popd
rm -rf android_build
}

#x86
export CC=${TOOLCHAIN}/bin/i686-linux-android${API}-clang
export CXX=${TOOLCHAIN}/bin/i686-linux-android${API}-clang++
PREFIX=../installed/android/x86
EXTRA_CFLAGS=""
ADDITIONAL_CONFIGURE_FLAG="--disable-asm"
HOST=i686-linux-android
CROSS_PREFIX=${TOOLCHAIN}/bin/i686-linux-android-
x264_build

#x86_64
export CC=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang
export CXX=${TOOLCHAIN}/bin/x86_64-linux-android${API}-clang++
PREFIX=../installed/android/x86_64
EXTRA_CFLAGS=""
ADDITIONAL_CONFIGURE_FLAG=""
HOST=x86_64-linux-android
CROSS_PREFIX=${TOOLCHAIN}/bin/x86_64-linux-android-
x264_build

#arm64-v8a
export CC=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang
export CXX=${TOOLCHAIN}/bin/aarch64-linux-android${API}-clang++
PREFIX=../installed/android/arm64-v8a
EXTRA_CFLAGS=""
ADDITIONAL_CONFIGURE_FLAG=""
HOST=aarch64-linux-android
CROSS_PREFIX=${TOOLCHAIN}/bin/aarch64-linux-android-
x264_build

#armeabi-v7a
export CC=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang
export CXX=${TOOLCHAIN}/bin/armv7a-linux-androideabi${API}-clang++
PREFIX=../installed/android/armeabi-v7a
EXTRA_CFLAGS=""
ADDITIONAL_CONFIGURE_FLAG=""
HOST=armv7a-linux-android
CROSS_PREFIX=${TOOLCHAIN}/bin/arm-linux-androideabi-
x264_build
