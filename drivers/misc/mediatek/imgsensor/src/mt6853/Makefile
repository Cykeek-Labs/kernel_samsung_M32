#
# Copyright (C) 2015 MediaTek Inc.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
#
# Makefile for misc devices that really don't fit anywhere else.
#
MTK_PLATFORM := $(subst ",,$(CONFIG_MTK_PLATFORM))

ifeq ($(CONFIG_MACH_MT6877),y)
MTK_DERIVED_PLATFORM := mt6877
endif

ifeq ($(CONFIG_MACH_MT6833),y)
MTK_DERIVED_PLATFORM := mt6833
endif

ifeq ($(CONFIG_MACH_MT6781),y)
MTK_DERIVED_PLATFORM := mt6781
endif

ifeq ($(CONFIG_MACH_MT6781),y)
CONFIG_MTK_PLATFORM_SENSOR := mt6853
else
CONFIG_MTK_PLATFORM_SENSOR := $(subst ",,$(CONFIG_MTK_PLATFORM))
endif

ifdef CONFIG_CAMERA_SAMSUNG_MODEL_NAME
ARCH_MTK_PROJECT := $(subst ",,$(CONFIG_CAMERA_SAMSUNG_MODEL_NAME))
else
ARCH_MTK_PROJECT := $(subst ",,$(CONFIG_ARCH_MTK_PROJECT))
endif

IMGSENSOR_DRIVER_PATH  := $(srctree)/drivers/misc/mediatek/imgsensor/src
MTK_DRIVER_PATH  := $(srctree)/drivers/misc/mediatek
COMMON_VERSION := v1_1
subdir-ccflags-y += -I$(IMGSENSOR_DRIVER_PATH)/common/$(COMMON_VERSION) \
	-I$(IMGSENSOR_DRIVER_PATH)/inc \
	-I$(IMGSENSOR_DRIVER_PATH)/common/sysfs \
	-I$(IMGSENSOR_DRIVER_PATH)/common/adaptive_mipi \
	-I$(MTK_DRIVER_PATH)/mmdvfs \
	-I$(srctree)/drivers/i2c/busses/

obj-y				+= ../common/$(COMMON_VERSION)/imgsensor.o
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_hw.o
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_i2c.o
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_legacy.o
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_proc.o
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_sensor_list.o
obj-y				+= ../common/$(COMMON_VERSION)/seninf.o
#ifneq ($(ARCH_MTK_PROJECT), k6833v1_64_mt6317)
#obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_pwr_seq.o
#endif

# Build sysfs folder
obj-$(CONFIG_IMGSENSOR_SYSFS) += ../common/sysfs/

# Build adaptive mipi folder
obj-$(CONFIG_CAMERA_ADAPTIVE_MIPI) += ../common/adaptive_mipi/

define FILTER_DRV
ifeq ($(wildcard $(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_project/$(ARCH_MTK_PROJECT)/$(1)),)
ifeq ($(wildcard $(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/$(1)),)
common_drv += ../common/$(COMMON_VERSION)/$(1)/
else
platform_drv += $(1)/
endif
else
project_drv += ./camera_project/$(ARCH_MTK_PROJECT)/$(1)/
endif
endef

$(foreach drv,$(subst $\",,$(CONFIG_CUSTOM_KERNEL_IMGSENSOR)),$(eval $(call FILTER_DRV,$(drv))))
obj-y				+= $(common_drv)

obj-y				+= $(platform_drv)

ifeq (,$(wildcard $(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_project/$(ARCH_MTK_PROJECT)/camera_hw))
ifeq (,$(wildcard $(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw_$(MTK_DERIVED_PLATFORM)))
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/common/$(COMMON_VERSION)/camera_hw
obj-y				+= camera_hw/
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_pwr_seq.o
else
obj-y				+= camera_hw_$(MTK_DERIVED_PLATFORM)/
obj-y				+= ../common/$(COMMON_VERSION)/imgsensor_pwr_seq.o
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw_$(MTK_DERIVED_PLATFORM)
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/common/$(COMMON_VERSION)/camera_hw
endif
ifneq ($(project_drv),)
obj-y				+= camera_project/$(ARCH_MTK_PROJECT)/
endif
else
obj-y				+= camera_project/$(ARCH_MTK_PROJECT)/
subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_project/$(ARCH_MTK_PROJECT)/camera_hw
#subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw_$(MTK_DERIVED_PLATFORM)
#subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/camera_hw
endif

#subdir-ccflags-y		+= -I$(IMGSENSOR_DRIVER_PATH)/common/$(COMMON_VERSION)/camera_hw

# Enable parallelism
subdir-ccflags-y += -DSENSOR_PARALLEISM


ifneq (,$(wildcard $(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/seninf_$(MTK_DERIVED_PLATFORM)))
subdir-ccflags-y += -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/seninf_$(MTK_DERIVED_PLATFORM)/
obj-y += seninf_$(MTK_DERIVED_PLATFORM)/
else
subdir-ccflags-y += -I$(IMGSENSOR_DRIVER_PATH)/$(MTK_PLATFORM)/seninf/
obj-y += seninf/
endif



$(info imgsensor subdir-ccflags-y = $(subdir-ccflags-y))


ifeq ($(ARCH_MTK_PROJECT), k6853v1_64_6360_alpha)
subdir-ccflags-y += -DNEED_LATE_INITCALL
endif

ifeq ($(CONFIG_MACH_MT6781),y)
subdir-ccflags-y += -DNEED_LATE_INITCALL
endif

ifeq ($(CONFIG_MACH_MT6877),y)
subdir-ccflags-y += -DNEED_LATE_INITCALL
endif

ifeq ($(ARCH_MTK_PROJECT), k6833v1_64_mt6317)
	subdir-ccflags-y += -DNEED_LATE_INITCALL
endif
