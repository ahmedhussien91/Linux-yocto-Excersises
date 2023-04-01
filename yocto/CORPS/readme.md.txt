# windows download

steps 

1. download and install Docket from  https://docs.docker.com/desktop/install/windows-install/
2. get corps image from https://hub.docker.com/r/crops/yocto/tags?page=1
3. pickup [ubuntu-22.04-builder](https://hub.docker.com/layers/crops/yocto/ubuntu-22.04-builder/images/sha256-2eb60a3c73b6e9970631cc70c5dd22b6eb3afb82d03106bf8d53b3550b57ca7f?context=explore)
4. execute command `docker pull crops/yocto:ubuntu-22.04-builder` in powershell -> new image `crops/yocto:ubuntu-22.04-builder`
5.  in `crops` dir ` git clone -b dunfell git://git.yoctoproject.org/poky.git` 
6. 