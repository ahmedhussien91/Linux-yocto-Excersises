CTNG_PATH="./qemu/crosstool-ng/"
CURRENT_PATH="$PWD"

cd $CTNG_PATH
./ct-ng arm-cortexa9_neon-linux-gnueabihf
./ct-ng source
./ct-ng build