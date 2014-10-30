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

2) import the local manifest:
git clone https://github.com/stevejcl/android_device_pipo_m8hd.git device/pipo/m8hd
cp device/pipo/m8hd/manifest/m8hd.xml .repo/local_manifests/

3) download the rom :
Place it in the source tree under devices/pipo/m8hd/pipo_rom/pipo_rom.img
run./fetch_prebuilts.sh

This will extract all binary blobs from that rom

4) build the source by calling brunch m8hd

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

