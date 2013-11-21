APPNAME = native-activity
ANDROID_TARGET = android-10
CDIR = jni
CSRC = $(wildcard $(CDIR)/*.c $(CDIR)/*.h)

all: bin/$(APPNAME)-debug.apk

bin/$(APPNAME)-debug.apk: $(CSRC)
	android update project -p ./ -n $(APPNAME) -t $(ANDROID_TARGET)
	ndk-build NDK_DEBUG=1
	ant debug

##############
clean:
	rm -rf bin libs obj
	rm -f build.xml local.properties proguard-project.txt project.properties

install: all
	sudo adb devices
	sudo adb install -r bin/$(APPNAME)-debug.apk

.PHONY: all clean install
