if [[ "$1" == "bb" || "$1" == "qemu" ]]; then
    # Do something if the argument is equal to "foo" or "bar"
    echo "The TARGET is equal to $1"
    ./download_dep.sh $1
    ./ctng_BuildToolchain.sh $1
    ./uboot_build.sh $1
    ./linux_build.sh $1
    ./busybox_build.sh $1

else
  # Do something if the argument is not equal to "foo" or "bar"
  echo "The usage:
            > ./build_all.sh <TARGET>
            Target: bb or qemu
            Ex. > ./build_all.sh bb"
fi