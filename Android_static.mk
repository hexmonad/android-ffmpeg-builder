LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := ffmpegexecutor
LOCAL_LDLIBS := -llog -ljnigraphics -lz -landroid
LOCAL_CFLAGS := -Wdeprecated-declarations
ANDROID_LIB := -landroid
LOCAL_SRC_FILES := ffmpeg_executor.c ffmpeg.c ffmpeg_filter.c ffmpeg_opt.c cmdutils.c

LOCAL_CFLAGS := -I$(FFMPEG_DIR)
# The order of static libraries listed in the LOCAL_STATIC_LIBRARIES is important.
# Dependent libraries must appear _before_ the other libraries they depend on, 
# otherwise the static linker will not be able to resolve symbols properly.
LOCAL_STATIC_LIBRARIES := libavdevice libavformat libavfilter libavcodec libswscale libavutil libswresample

include $(BUILD_SHARED_LIBRARY)
$(call import-add-path, $(FFMPEG_DIR))
$(call import-module, android-build/$(CPU))
