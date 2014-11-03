#!/bin/bash
ROM_IMG="20140606.rar"
MD5="078ecdc6e156502f7f828dc101fb034b"

function show_message {
	echo -e "\e[0;32m> $1\e[m"
}


if [ ! -e "pipo_rom/$ROM_IMG" ]; then
	if [ ! -e pipo_rom ]; then
		mkdir pipo_rom
	fi

	show_message "could not find required rom. please download $ROM_IMG from:"
	show_message "http://pan.baidu.com/wap/link?uk=386307513&shareid=2688745901&third=0\n"
	ROM_FOLDER=`pwd`
	show_message "> then, please place ssave it as $ROM_FOLDER/$ROM_IMG\n"
	exit 0
	#show_message "will now try to fetch the firmware upgrade from pipo (http://www.pipo.cn/En/index.php?m=About&a=gujian_show&id=188)"
	#wget $ROM_URL -O pipo_rom/$ROM_IMG || exit 0
fi

MD5_ROM=`md5sum pipo_rom/$ROM_IMG|cut -d " " -f1`
if [ "$MD5" != "$MD5_ROM" ]; then
	show_message "ERROR: md5sum of rom ($MD5_ROM) mismatch to expected md5sum ($MD5). please download the right rom"
	exit 0
fi


cd pipo_rom || exit 0

if [ ! -e rktools ]; then
	show_message -e "\e[0;32m> will now get tools\e[m"
	mkdir rktools
	cp ../rktools/* rktools/
	#show_message -e "\e[0;32m> will now fetch and build rktools\e[m"
	#git clone https://github.com/rk3066/rk-tools.git rktools
	#cd rktools
	#make || exit 0
    #    cd ..
fi

#if [ ! -e bootimg-tools ]; then
#	show_message "will now build unpackbootimg"
#	git clone https://github.com/pbatard/bootimg-tools.git bootimg-tools
#	cd bootimg-tools	
#	make
#	cd ..
#fi

if [ ! -e extracted ]; then
	mkdir extracted 
fi
cd extracted

if [ ! -e Image ]; then
	show_message "unpacking fw upgrade..."
	unrar x ../$ROM_IMG || exit 0
	mv M8*.img pipo_rom.img || exit 0
	show_message "running img_unpack"
    mkdir output
    ../rktools/rkImageMaker -unpack pipo_rom.img output || exit 0

	show_message "unpacking using afptool"
	../rktools/afptool -unpack output/firmware.img ./ || exit 0

    rm -f output/firmware.img
    rm -f output/boot.bin
	rmdir output	
		
	show_message "extracting boot.img and system.img"
	mkdir tmp
	mv * tmp 2> /dev/null #suppress warning
	mv tmp/Image .
	rm -rf tmp
fi

if [ ! -e root ]; then
	show_message "extracting the kernel and the root fs from boot.img"
    ../rktools/imgrepackerrk Image/boot.img
    cp Image/boot.img.dump/kernel kernel

	mkdir root; 
    cp -R Image/boot.img.dump/ramdisk.dump/* root
	
	rm -Rf Image/boot.img.dump/ramdisk.dump
	rm -Rf Image/boot.img.dump

fi

if [ ! -e system ]; then
	mkdir system_tmp 
	show_message "mounting sytem.img using a loopback device. this requires root privilegues (sudo mount)"
	sudo mount -o loop -t ext4 Image/system.img system_tmp || exit 0
	mkdir system
	show_message "copying all files to sytem folder"
	sudo cp -ar system_tmp/* system/ || exit 0
	USER=`whoami`
	show_message "changing ownership of all files to $USER:$USER"
	sudo chown $USER:$USER -R system/* || exit 0
	show_message "ok, done. will umount loopback device"
	sudo umount system_tmp || exit 0
	rm -rf system_tmp
fi

cd ../../

OUT_FILE_MK="proprietary_files.mk"
show_message "will create $OUT_FILE_MK now ..."

echo -ne "#proprietary_files.txt -> mk file\n\nPRODUCT_COPY_FILES += " > $OUT_FILE_MK
while read f; do
	#skip empty lines
	[ -z "$f" ] && continue 

	filename="pipo_rom/extracted/$f"
	if [[ ! "$f" =~ ^#.* ]] &&  [[ ! "$f" =~ *$ ]]; then
		#ignore coments/commented out stuff
		if [ -e $filename ]; then
			target=`echo $f | sed -r "s/.3.0.36\+//"`
			echo "    device/pipo/m8hd/$filename:$target \\" >> $OUT_FILE_MK
		else
			show_message "> ignoring $filename (not found)";
		fi
	fi
done < proprietary_files.txt
echo "" >> $OUT_FILE_MK

show_message "done..."
