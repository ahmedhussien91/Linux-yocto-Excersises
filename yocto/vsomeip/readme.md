# vsomeip project

This Document describe the steps you need to do to complete integration of [vsomeip](https://github.com/COVESA/vsomeip) open source stack in your image, and start developing your applications.

We will describe the following steps in this document:

1. we will start by creating an image by following steps in [1.building_Raspberrypi_image](https://github.com/ahmedhussien91/Linux-yocto-Excersises/blob/main/yocto/1.building_Raspberrypi_image/readme.md)

2. Implement a custom layer (**meta-custom**) to include our applications

3. write a recipe (**vsomeip_1.0.bb**) for compiling and integrating [vsomeip](https://github.com/COVESA/vsomeip) in our custom layer

4. write our custom image (**vsomeip-image.bb**) and include components included in (**core-image-base**) + "openssh" + "vsomeip"

5. bitbake new **vsomeip-image.bb** image and generate SDK

6. build applications of vsomeip using SDK

7. start new image and transfer the vsomeip applications to target using (**SCP**)

8. run applications on target ssh instances for each application 

   