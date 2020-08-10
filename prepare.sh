apt-get update
apt-get install -y build-essential bc python curl git zip ftp gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi libssl-dev lftp zstd wget libfl-dev 

cd $HOME
rm -rf AnyKernel3
git clone --depth=1 https://github.com/NoobLiROM/AnyKernel3.git
wget -c https://dl.akr-developers.com/?file=CBL/Candy_clang-20200902.tar.zst -O CBL.tar.zst
mkdir cbl
zstd -d CBL.tar.zst
tar -xvf CBL.tar -C cbl
