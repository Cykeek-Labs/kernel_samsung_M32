#!/bin/bash
#set -e
# Clone kernel
echo -e "$green << cloning kernel >> \n $white"
git clone https://github.com/RaiMaru24/kernel_samsung_m32 m32
cd m32

# Remove
rm -rf out

KERNEL_DEFCONFIG=m32_defconfig
date=$(date +"%Y-%m-%d-%H%M")
export ARCH=arm64
export SUBARCH=arm64
export zipname="Alenchacha-M32-${date}.zip"

# Tool Chain
echo -e "$green << cloning gcc from arter >> \n $white"
git clone --depth=1 https://github.com/mvaisakh/gcc-arm64 "$HOME"/gcc64
git clone --depth=1 https://github.com/mvaisakh/gcc-arm "$HOME"/gcc32
export PATH="$HOME/gcc64/bin:$HOME/gcc32/bin:$PATH"
export STRIP="$HOME/gcc64/aarch64-elf/bin/strip"
export KBUILD_COMPILER_STRING=$("$HOME"/gcc64/bin/aarch64-elf-gcc --version | head -n 1)

# Clang
echo -e "$green << cloning clang >> \n $white"
git clone --depth=1 https://github.com/kdrag0n/proton-clang.git "$HOME"/clang
# export PATH="$HOME/clang/bin:$PATH"
# export KBUILD_COMPILER_STRING=$("$HOME"/clang/bin/clang --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g' -e 's/[[:space:]]*$//')


# Speed up build process
MAKE="./makeparallel"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out CC=clang
make -j$(nproc --all) O=out \
                              ARCH=arm64 \
                              LLVM=1 \
                              LLVM_IAS=1 \
                              AR=llvm-ar \
                              NM=llvm-nm \
                              LD=ld.lld \
                              OBJCOPY=llvm-objcopy \
                              OBJDUMP=llvm-objdump \
                              STRIP=llvm-strip \
                              CC=clang \
                              CROSS_COMPILE=aarch64-linux-gnu- \
                              CROSS_COMPILE_ARM32=arm-linux-gnueabi-  2>&1 | tee out/error.log
                                                  
export IMG="$MY_DIR"/out/arch/arm64/boot/Image.gz
export dtbo="$MY_DIR"/out/arch/arm64/boot/dtbo.img
export dtb="$MY_DIR"/out/arch/arm64/boot/dtb.img

# Remove
cat out/error.log | curl -F 'f:1=<-' ix.io
sleep 2s;
rm -rf out/
