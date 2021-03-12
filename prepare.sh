apt-get update
apt-get install -y build-essential bc python curl git zip ftp gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi libssl-dev lftp wget libfl-dev 

cd $HOME
rm -rf AnyKernel3
git clone --depth=1 https://github.com/NoobLiROM/AnyKernel3.git
git clone --depth=1 https://github.com/kdrag0n/proton-clang cbl
