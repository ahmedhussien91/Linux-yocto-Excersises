LOOP_DEV=$(df -h ./sdcard/1 | awk 'NR==2{print $1}' | sed 's/p1//g')
sudo losetup -d $LOOP_DEV
echo "release loop device: $LOOP_DEV"

sudo umount sdcard/1
sudo umount sdcard/2
sudo umount sdcard/3

rm sd.img
rm -rf sdcard