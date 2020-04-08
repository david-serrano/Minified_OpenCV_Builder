How to build OpenCV from sources for Android on Windows
-------------------------------------------------------
This is a step by step guide on how to get the source code and tools necessary for building OpenCV from scratch.


Downloading required packages:
------------------------------
* Download the Android NDK:</br> 
	ndk-r20 was used as of the time of writing.

* Download the Android SDK:</br> 
	Scroll down to the section that allows you to download the SDK tools only if you don’t also want Android Studio to be 		installed. 

* Download the OpenCV sources:</br> 
	OpenCV 3.4.3 was used as of the time of writing. (https://github.com/opencv/opencv/releases/tag/3.4.3)

* Download Ant (https://ant.apache.org/bindownload.cgi):</br> 
	Ant v1.9.14 was used as of the time of writing.

* Download Ninja (https://github.com/ninja-build/ninja/releases):</br> 
	** Add the folder which contains ninja.exe to your PATH in Environment Variables. Eg: D:\Program\Ninja **
	
* Download CMake (latest .msi or .zip from https://cmake.org/download/):</br> 
 	When installing, select the option to add CMake to the system PATH
	
	** Check CMake is in your PATH **</br> 
 		- If it is not, add Add the CMake/bin folder to your PATH Environment Variables. Eg: D:\Programs\CMake\bin

* Download the build script (build_opencv_android.sh). </br> 
	If you can’t run shell scripts from your command window, install Gitbash or get WSL from the Windows store.

Setting up the build environment: 
---------------------------------
1) Create a directory somewhere on your computer (this will be the [build directory]).
2) Copy the OpenCV sources into a folder called opencv.
3) Inside the [build directory] create a buildall folder.
4) Copy the build script inside the buildall folder.

Your  folder structure should look like this:</br>
    [build directory]</br>
      |_ opencv </br>
      | |_ the OpenCV source files</br> 
      |</br>
      |_ buildall</br>
         |_ build_opencv_android.sh</br>


Editing the script:
-------------------
* Open the script with your editor of choice - I like Notepad++.

Inside you will see a few exports at the top, we are interested in the following:
* ANDROID_NDK</br> 
	Edit the path in this string to point at your ndk directory.
* ANDROID_SDK</br> 
	Edit the path in this string to point at your sdk directory.
* ANT_EXECUTABLE</br> 
	Edit the path in this string to point at your Ant executable.</br> 
	NB: Make sure it is pointing at the ant.bat file.
* TOOLCHAIN_FILE</br> 
	Update the first part of the string path to point at your ndk directory.
	It is worth checking the path for the cmake file is valid for your version if you’ve not downloaded android-ndk-r20.

Other variables that might need tweaking:
-----------------------------------------
* SDK_TARGET</br> 
	This is the target build API.
* BUILD_TOOLS_VERSION</br> 
	This is the target Build tools, may need to vary if we’re upgrading to later OpenCV releases.

If you don’t want to build for all supported architectures (see below), comment out the build_opencv [architecture] lines that you don’t want by prepending a #.</br>
Also comment out the mkdir [architecture] and the copy_library [architecture] to avoid confusion.

Executing the script:
---------------------
* Open a command line window
* Navigate to the [build directory]/buildall folder.
* Execute ./build_opencv_android.sh
* Wait until the process completes (if you’re building for all architectures this might take a long while).
* Once the process is done you will see a log in the console saying  "----- DONE! -----".

Obtaining the binaries:
-----------------------
* Open your [build directory]. 
* There will be a new folder called libraries inside it.
* Inside this folder you will find subfolders for all the architectures that were built on the run, containing a file named libopencv_java3.so. 
* Copy these files into the relevant architecture folders in the jniLibs directory of your Android project.

Troubleshooting:
----------------
* If there are any issues building the binaries, I would recommend deleting all of the build folders, as existing remains from previous runs will cause it to break.</br> 
	- delete all build_[architecture] folders from the buildall folder</br> 
	- delete the top level libraries folder

Other notes:
------------
The script will currently build for the following chip architectures:</br> 
armeabi-v7a</br> 
arm64-v8a</br> 
x86</br> 
x86_64</br> 

The following chip architectures are not supported by ndk-r20</br> 
mips</br> 
mips64</br> 
armeabi</br> 

If you want to build for these chipsets, I would recommend downloading a prior version of the android NDK (android-ndk-r15c) and updating the relevant paths as detailed in the "Editing the script" section. There is also an example in the commented out section at the bottom of the script file
