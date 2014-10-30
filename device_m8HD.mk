TARGET_BUILD_TYPE := debug #release

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

$(call inherit-product-if-exists, vendor/pipo/m8hd/m8hd-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/pipo/m8hd/overlay/aosp

TARGET_PREBUILT_KERNEL := device/pipo/m8hd/pipo_rom/extracted/kernel

LOCAL_PATH := device/pipo/m8hd

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := $(LOCAL_PATH)/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

# maybe we should use the tablets init rc?
#TARGET_PROVIDES_INIT_RC := device/pipo/m8hd/_init.rc

# system files
PRODUCT_COPY_FILES += \
        device/pipo/m8hd/initlogo.rle:root/initlogo.rle
	#device/pipo/m8hd/ueventd.rc:root/ueventd.rc \
	#device/pipo/m8hd/ueventd.rk30board.rc:root/ueventd.rk30board.rc \
	#device/pipo/m8hd/prebuilt/rk30xxnand_ko.ko.3.0.36+:root/rk30xxnand_ko.ko.3.0.36+ \
	#device/pipo/m8hd/prebuilt/rk30xxnand_ko.ko.3.0.36+:root/rk30xxnand_ko.ko \
	#device/pipo/m8hd/prebuilt/initlogo.rle:root/initlogo.rle 
#	device/pipo/m8hd/prebuilt/charger:root/charger
        #device/rockchip/rk3188/rk29-ipp.ko:root/rk29-ipp.ko \
        #device/rockchip/rk3188/ueventd.goldfish.rc:root/ueventd.goldfish.rc

#copy init scripts
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,init.*,device/pipo/m8hd/,root)
#fstab
PRODUCT_COPY_FILES += $(call find-copy-subdir-files,fstab.*,device/pipo/m8hd/,root)


# copy prebuilt files
include device/pipo/m8hd/proprietary_files.mk

# copy the builder script
PRODUCT_COPY_FILES += \
        device/pipo/m8hd/custom_boot.sh:custom_boot.sh \
	device/pipo/m8hd/flash.sh:flash.sh

# hardware-specific feature permissions
PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
        frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
        frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
        frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
        frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
        frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.sensor.gyroscope.xml


PRODUCT_CHARACTERISTICS := tablet
TARGET_BOOTANIMATION_NAME := horizontal-1200

# Camera
PRODUCT_PACKAGES += \
        Camera \
        camera.rk30board 

# Audio
PRODUCT_PACKAGES += \
        audio.primary.default \
        audio.primary.rk30board \
        audio_policy.default \
        audio_policy.rk30board \
        alsa.default \
        acoustics.default \
        audio.r_submix.default \
        tinyplay \
        tinycap \
        tinymix \
        audio.a2dp.default \
        audio.usb.default \
        libtinyalsa \
        libaudioutils


PRODUCT_PACKAGES += \
        librs_jni \
        com.android.future.usb.accessory

# filesystem tools
PRODUCT_PACKAGES += \
        make_ext4fs \
        setup_fs \
        static_busybox \
        utility_make_ext4fs \
        libstagefrighthw

# usb stuff
DEFAULT_PROPERTY_OVERRIDES += \
        service.adb.root=1 \
        ro.secure=0 \
        ro.allow.mock.location=1 \
        ro.debuggable=1 \
        ro.cwm.forbid_format=/misc,/kernel,/recovery 


ADDITIONAL_DEFAULT_PROPERTIES += \
	service.adb.root=1 \
        ro.secure=0 \
        ro.allow.mock.location=1 \
        ro.debuggable=1

#wifi
PRODUCT_PACKAGES += \
	wpa_supplicant.conf \
	libnetcmdiface


#PRODUCT_COPY_FILES +=   $(LOCAL_KERNEL):kernel

#$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)
#$(call inherit-product, build/target/product/full.mk)
#do not inherit phone stuff (MSIMIcc crashes)
$(call inherit-product, build/target/product/full_base.mk)


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := full_m8hd
PRODUCT_DEVICE := m8hd
