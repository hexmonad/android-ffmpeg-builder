LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := ffmpegexecutor
LOCAL_LDLIBS := -llog -ljnigraphics -lz -landroid
LOCAL_CFLAGS := -Wdeprecated-declarations
ANDROID_LIB := -landroid
LOCAL_SRC_FILES := ffmpeg_executor.c ffmpeg.c ffmpeg_filter.c ffmpeg_opt.c cmdutils.c

LOCAL_CFLAGS := -I$(FFMPEG_DIR)
LOCAL_SHARED_LIBRARIES := libavformat libavcodec libswscale libavutil libswresample libavfilter libavdevice

include $(BUILD_SHARED_LIBRARY)
$(call import-add-path, $(FFMPEG_DIR))
$(call import-module, android-build/$(CPU))
