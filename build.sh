#!/bin/bash
clang_path="${HOME}/cbl/bin/clang"
gcc_path="${HOME}/cbl/bin/aarch64-linux-gnu-"
gcc_32_path="${HOME}/cbl/bin/arm-linux-gnueabi-"

timedatectl set-timezone Asia/Shanghai

source=`pwd`
START=$(date +"%s")

date="`date +"%m%d%H%M"`"

args="-j$(nproc --all) O=out \
	ARCH=arm64 "

print (){
case ${2} in
	"red")
	echo -e "\033[31m $1 \033[0m";;

	"blue")
	echo -e "\033[34m $1 \033[0m";;

	"yellow")
	echo -e "\033[33m $1 \033[0m";;

	"purple")
	echo -e "\033[35m $1 \033[0m";;

	"sky")
	echo -e "\033[36m $1 \033[0m";;

	"green")
	echo -e "\033[32m $1 \033[0m";;

	*)
	echo $1
	;;
	esac
}

print "You are building version:$date" yellow

args+="LOCALVERSION=-$date "

args+="CC=$clang_path \
	CLANG_TRIPLE=aarch64-linux-gnu- \
	CROSS_COMPILE=$gcc_path \
	AR=${HOME}/cbl/bin/llvm-ar \
	NM=${HOME}/cbl/bin/llvm-nm \
	OBJCOPY=${HOME}/cbl/bin/llvm-objcopy \
	OBJDUMP=${HOME}/cbl/bin/llvm-objdump \
	STRIP=${HOME}/cbl/bin/llvm-strip "

args+="CROSS_COMPILE_ARM32=$gcc_32_path "

clean(){
	make mrproper
	make $args mrproper
}

build_dipper(){
	export KBUILD_BUILD_USER="dipper"
	export KBUILD_BUILD_HOST="ALKALiKong"
	print "Building Kernel for dipper..." blue
	make $args dipper_defconfig&&make $args
	if [ $? -ne 0 ]; then
    echo "Error while building for dipper!"
	else
	mkzip "dipper-${1}"
    fi
}

mkzip (){
	zipname="(${1})Li-Kernel-$date.zip"
	cp -f out/arch/arm64/boot/Image.gz-dtb ~/AnyKernel3
	cd ~/AnyKernel3
	zip -r "$zipname" *
	mv -f "$zipname" ${HOME}
	cd ${HOME}
	cd $source
	print "All done.Find it at ${HOME}/$zipname" green
	tg_upload
}

tg_upload(){
cd ${HOME}
curl -s https://api.telegram.org/bot"${bot_token}"/sendDocument -F document=@"${zipname}" -F chat_id="${chat_id}"
}

./prepare.sh
clean
build_dipper
