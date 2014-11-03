testing cm11 port to pipo m8hd

this is work in progress!

credits goes to fishpepper who makes the magic on M7pro

what is working?

what is not working?

NOT tested:
- GSM module (mine does not have it)

TO TEST:

HOW TO BUILD
=============================

1)
set up a plain cm11 build tree (see cm doc)
default directory is

$ cd ~/android/system/

2)Add Local_manifests
create directory

$ mkdir -p  .repo/local_manifests

<code>

<?xml version="1.0" encoding="UTF-8"?>
<manifest>
<project path="device/pipo/m8hd" name="stevejcl/android_device_pipo_m8hd" remote="github" revision="master"/>
</manifest>

</code>

Save the file in .repo/local_manifests/m8hd.xml

3)Download the source code
To start the download of all the source code to your computer: 

$ repo sync -c

4)Get prebuilt apps

$ ./vendor/cm/get-prebuilts

You won't see any confirmation- just another prompt. But this should cause some prebuilt apps to be loaded and installed into the source code. Once completed, this does not need to be done again. 

then enter: 

$ source build/envsetup.sh


3) download the rom :

First create directory to save the rom

$ mkdir -p  device/pipo/m8hd/pipo_rom

download here : http://pan.baidu.com/wap/link?uk=386307513&shareid=2688745901&third=0

Name it 20140606.rar and place it in the source tree under device/pipo/m8hd/pipo_rom/20140606.rar

Then run

$ ./device/pipo/m8hd/fetch_prebuilts.sh

This will extract all binary blobs from that rom

4) build the source by calling brunch m8hd

$ brunch m8hd


HOW TO FLASH
=============================

right now i did not test cwm installer based installation,
i used rkflash to flash it.

DO THIS ON YOUR OWN RISK!!!!

0) boot into flashloader: shut down tablet by long press. press and hold ESC while
pressing power on for 5-8s. Then release both.

1) verify that your board is the same as mine by running > rkflashtool p
FIRMWARE_VER:4.4.2
MACHINE_MODEL:m8hd
MACHINE_ID:007
MANUFACTURER:RK30SDK
MAGIC: 0x5041524B
ATAG: 0x60000800
MACHINE: 3066
CHECK_MASK: 0x80
KERNEL_IMG: 0x60408000
#RECOVER_KEY: 1,1,0,20,0
CMDLINE:console=ttyFIQ0 androidboot.console=ttyFIQ0 init=/init initrd=0x62000000,0x00800000 mtdparts=rk29xxnand:0x00002000@0x00002000(misc),0x00006000@0x00004000(kernel),0x00006000@0x0000a000(boot),0x00010000@0x00010000(recovery),0x00020000@0x00020000(backup),0x00040000@0x00040000(cache),0x00e00000@0x00080000(userdata),0x00002000@0x00e80000(metadata),0x00002000@0x00e82000(kpanic),0x00140000@0x00e84000(system),-@0x00fc4000(user)

2) verify the adresses for boot and system location (swap address before and after the @)
0x00006000@0x0000a000(boot)
0x00140000@0x00e84000(system)

3) flash the images (this will reboot after flashing):
./flash.sh

NOTE: the flash.sh script checking the md5sum is currently untested

(do not worry about the premature warning at boot.img, our image is smaller)

