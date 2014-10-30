## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := m8hd

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/pipo/m8hd/device_m8hd.mk)

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := m8hd
PRODUCT_NAME := cm_m8hd
PRODUCT_BRAND := pipo
PRODUCT_MODEL := m8hd
PRODUCT_MANUFACTURER := pipo
