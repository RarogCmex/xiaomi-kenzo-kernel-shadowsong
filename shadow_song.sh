#
# Custom build script for Shadow kernel
#
# Copyright 2016 Umang Leekha (Umang96@xda)
#
# This software is licensed under the terms of the GNU General Public
# License version 2, as published by the Free Software Foundation, and
# may be copied, distributed, and modified under those terms.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Please maintain this if you use this script or any part of it.
#
DEVICE="Kenzo"
yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
echo -e ""
echo -e "$gre ====================================\n\n Welcome to Shadow building program !\n\n ===================================="
echo -e "$gre \n 1.Build Shadow Clean\n\n 2.Build Shadow Dirty\n"
echo -n " Enter your choice:"
read qc
echo -e "$white"
KERNEL_DIR=$PWD
cd $KERNEL_DIR/arch/arm/boot/dts/
rm *.dtb > /dev/null 2>&1
cd $KERNEL_DIR
Start=$(date +"%s")
DTBTOOL=$KERNEL_DIR/dtbTool
cd $KERNEL_DIR
#
#
if [ $qc == 1 ]; then
echo -e "$yellow Running make clean before compiling \n$white"
make clean > /dev/null
fi
export ARCH=arm64
#
# Export Clang path
#
export PATH="${PATH}:${HOME}/toolchains/clang-r450784e/bin/:${HOME}/toolchains/arm-gnu-toolchain-14.2.rel1-x86_64-aarch64-none-linux-gnu/bin:${HOME}/toolchains/arm-gnu-toolchain-14.3.rel1-x86_64-arm-none-linux-gnueabihf/bin"
export KBUILD_BUILD_USER="rarogcmex"
#
# Do Kenzo Configs
#
make shadow_song_defconfig
#
# Build Shadow Kernel
#
make	-j$(nproc) \
	CC=clang \
	CLANG_TRIPLE=aarch64-none-linux-gnu- \
	CROSS_COMPILE_ARM32=arm-none-linux-gnueabihf- \
	CROSS_COMPILE=aarch64-none-linux-gnu-


#	OBJDUMP=llvm-objdump STRIP=llvm-strip \
#	AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy \
#
# Append date,time and Export Image and device tree
#
time=$(date +"%d-%m-%y-%T")
date=$(date +"%d-%m-%y")
#
#
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
mv $KERNEL_DIR/arch/arm64/boot/dt.img $KERNEL_DIR/build/tools/dt.img
cp $KERNEL_DIR/arch/arm64/boot/Image $KERNEL_DIR/build/tools/Image
#
#
zimage=$KERNEL_DIR/arch/arm64/boot/Image
if ! [ $zimage ]; then
echo -e "$red << Failed to compile zImage, fix the errors first >>$white"
else
cd $KERNEL_DIR/build
rm *.zip > /dev/null 2>&1
#
# Zip Flash Tools and make shadow zip
#
echo -e "$yellow\n Build succesful, generating flashable zip now \n $white"
#
zip -r Shadow-Trax-Kernel-$date.zip * > /dev/null
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$yellow $KERNEL_DIR/export/$VERSION/Shadow-Trax-Kernel-$date.zip \n$white"
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white"
fi
cd $KERNEL_DIR
