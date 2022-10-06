# download and build crosstool-ng
git clone https://github.com/crosstool-ng/crosstool-ng
cd crosstool-ng/
git checkout 25f6dae84
./bootstrap
./configure --enable-local
make
./ct-ng arm-cortexa9_neon-linux-gnueabihf
./ct-ng build
