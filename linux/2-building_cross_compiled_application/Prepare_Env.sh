# download and build crosstool-ng
sudo apt install build-essential git autoconf bison flex texinfo help2man gawk \
libtool-bin libncurses5-dev unzip
git clone https://github.com/crosstool-ng/crosstool-ng
cd crosstool-ng/
git checkout 25f6dae84
./bootstrap
./configure --enable-local
make
./ct-ng arm-cortexa9_neon-linux-gnueabihf
./ct-ng build
