#!/bin/bash
# Script to build opencv for android for x86,x86_64, armeabi-v7a, arm64-v8a
# Must be run from a subdirectory that contains a directory called 'opencv' in the parent directory with the
# opencv sources (from git or a tarball)
# Final builds go to parent directory/libraries/architecture/lib_opencv_java3.so

export ANDROID_NDK="D:/androidNdks/android-ndk-r20"
export ANDROID_SDK="D:/androidSdk/"
export ANT_EXECUTABLE="D:/Programs/apache-ant-1.9.14/bin/ant.bat"
export MAKE_PROGRAM="ninja"
export SDK_TARGET=21
export CONFIG_TYPES="Release"
export TOOLCHAIN_FILE="D:/androidNdks/android-ndk-r20/build/cmake/android.toolchain.cmake"
export BUILD_SHARED_LIBS=OFF 
export BUILD_TOOLS_VERSION=25.0.0
export ANDROID_STL="c++_static" 

function build_opencv {
  ABI=$1

  file="build_${ABI}"
  echo "------ BUILDING 3.4.3 for $ABI -------------"
 
  mkdir $file
  pushd build_$ABI

  cmake -G"Ninja" -DANDROID_ARM_NEON=ON -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON -DBUILD_ANDROID_PROJECTS:BOOL=OFF -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS -DINSTALL_CREATE_DISTRIB=ON -DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM -DCMAKE_CONFIGURATION_TYPES=CONFIG_TYPES -DANDROID_SDK_TARGET=$SDK_TARGET -DANDROID_ABI=$ABI -DANT_EXECUTABLE=$ANT_EXECUTABLE -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE -DANDROID_STL=$ANDROID_STL -DANDROID_SDK_BUILD_TOOLS_VERSION=$BUILD_TOOLS_VERSION -DANDROID_FUNCTION_LEVEL_LINKING=ON -DANDROID_FORBID_SYGWIN=ON -DANDROID_NO_EXEC_STACK=ON -DANDROID_NO_UNDEFINED=ON -DANDROID_TOOLCHAIN=clang -DWITH_CPUFEATURES=ON -DWITH_CUFFT=ON -DANDROID_GOLD_LINKER=ON -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O2 -g -DNDEBUG" -DCMAKE_C_FLAGS_MINSIZEREL="-Os -DNDEBUG" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g -DNDEBUG" -DCMAKE_CXX_FLAGS_MINSIZEREL="-Os -DNDEBUG" -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -DDEBUG -D_DEBUG" -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG" -DANDROID_NDK_HOST_X64=ON -DENABLE_PIC=ON -DENABLE_CCACHE=ON -DBUILD_JAVA=ON -DBUILD_opencv_java=ON -DBUILD_opencv_java_bindings_generator=ON -DBUILD_opencv_python_bindings_generator=OFF -DINSTALL_ANDROID_EXAMPLES=OFF -DANDROID_EXAMPLES_WITH_LIBS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_DOCS=OFF -DWITH_OPENCL=OFF -DWITH_IPP=ON -DBUILD_ANDROID_EXAMPLES=OFF -DANDROID_RELRO=ON -DANDROID_SO_UNDEFINED=ON -DANDROID_STL_FORCE_FEATURES=ON -DBUILD_ANDROID_EXAMPLES_WITH_LIBS=OFF -DBUILD_ANDROID_PACKAGE=ON -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_FAT_JAVA_LIB=ON -DBUILD_JASPER=OFF  -DBUILD_JPEG=ON  -DBUILD_OPENEXR=OFF  -DBUILD_PACKAGE=OFF  -DBUILD_PERF_TESTS=OFF -DBUILD_PNG=OFF -DBUILD_WEBP=ON -DBUILD_TBB=OFF -DBUILD_TESTS=OFF -DBUILD_TIFF=OFF -DBUILD_WITH_DEBUG_INFO=OFF -DBUILD_ZLIB=OFF -DBUILD_opencv_androidcamera=OFF -DBUILD_opencv_apps=OFF -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_contrib=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_core=ON -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_gpu=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_imgproc=ON -DBUILD_opencv_imgcodecs=ON -DBUILD_opencv_legacy=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_nonfree=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_ocl=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_utils=ON -DBUILD_opencv_superres=OFF -DBUILD_opencv_ts=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videostab=OFF -DBUILD_opencv_world=OFF -DWITH_CUBLAS=OFF -DWITH_CUDA=OFF -DWITH_CUFFT=OFF -DWITH_EIGEN=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=ON -DWITH_WEBP=ON -DWITH_OPENCL=OFF -DWITH_OPENEXR=OFF -DWITH_OPENMP=OFF -DWITH_PNG=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF ../../opencv  
  ninja -j5
  ninja install/strip

  popd
}

function copy_library {
	architecture=$1
	echo "copying ${architecture}"
	cp -R buildall/build_$architecture/install/sdk/native/libs/$architecture/libopencv_java3.so libraries/$architecture/
}

build_opencv x86
build_opencv x86_64 
build_opencv armeabi-v7a
build_opencv arm64-v8a

echo "----- BUILDING COMPLETE ----"

cd ..
mkdir libraries
pushd libraries
mkdir x86
mkdir x86_64 
mkdir armeabi-v7a
mkdir arm64-v8a
popd

copy_library x86
copy_library x86_64 
copy_library armeabi-v7a
copy_library arm64-v8a

echo "----- DONE! -----"


############################################################################
# OBSOLETE: 
# - Mingw32 approach 
# - OLDER NDK Example
# - Includes deprecated mips, mips64, armeabi
############################################################################

#export ANDROID_NDK="D:/androidNdks/android-ndk-r15c"
#export ANDROID_SDK="D:/androidSdk/"
#export ANT_EXECUTABLE="D:/Programs/apache-ant-1.9.14/bin/ant.bat"
#export MAKE_PROGRAM="D:/Programs/Mingw/bin/mingw32-make.exe"
#export SDK_TARGET=21
#export CONFIG_TYPES="Release"
#export TOOLCHAIN_FILE="D:/AndroidNdks/android-ndk-r15c/build/cmake/android.toolchain.cmake"
#export BUILD_SHARED_LIBS=ON
#export BUILD_FAT_JAVA_LIB=ON #-DBUILD_JAVA_FAT_LIB=$BUILD_FAT_JAVA_LIB 
#export BUILD_TOOLS_VERSION=25.0.0
#export ANDROID_STL="gnustl_static" #"gnustl_static"


#function build_opencv {
#  ABI=$1
#
#  file="build_${ABI}"
#  echo "------ BUILDING 3.4.3 for $ABI -------------"
# 
#  mkdir $file
#  pushd build_$ABI
#
#  
#  cmake -G"MinGW Makefiles" -DCMAKE_MAKE_PROGRAM=$MAKE_PROGRAM -DCMAKE_CONFIGURATION_TYPES=CONFIG_TYPES -DANDROID_SDK_TARGET=$SDK_TARGET -DANDROID_ABI=$ABI -DANT_EXECUTABLE=$ANT_EXECUTABLE -DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN_FILE -DANDROID_STL=$ANDROID_STL -DANDROID_SDK_BUILD_TOOLS_VERSION=$BUILD_TOOLS_VERSION -DANDROID_FUNCTION_LEVEL_LINKING=ON -DANDROID_FORBID_SYGWIN=ON -DANDROID_NO_EXEC_STACK=ON -DANDROID_NO_UNDEFINED=ON -DANDROID_TOOLCHAIN=clang -DBUILD_SHARED_LIBS=$BUILD_SHARED_LIBS -DWITH_CPUFEATURES=ON -DWITH_CUFFT=ON -DANDROID_GOLD_LINKER=ON -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O2 -g -DNDEBUG" -DCMAKE_C_FLAGS_MINSIZEREL="-Os -DNDEBUG" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g -DNDEBUG" -DCMAKE_CXX_FLAGS_MINSIZEREL="-Os -DNDEBUG" -DCMAKE_CXX_FLAGS_DEBUG="-O0 -g -DDEBUG -D_DEBUG" -DCMAKE_CXX_FLAGS_RELEASE="-O3 -DNDEBUG" -DANDROID_NDK_HOST_X64=ON -DENABLE_PIC=ON -DENABLE_CCACHE=ON -DBUILD_JAVA=ON -DBUILD_opencv_java=ON -DBUILD_opencv_java_bindings_generator=ON -DBUILD_opencv_python_bindings_generator=OFF -DINSTALL_ANDROID_EXAMPLES=OFF -DANDROID_EXAMPLES_WITH_LIBS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_ANDROID_PROJECTS=OFF -DBUILD_DOCS=OFF -DWITH_OPENCL=OFF -DWITH_IPP=ON -DBUILD_ANDROID_EXAMPLES=OFF -DANDROID_RELRO=ON -DANDROID_SO_UNDEFINED=ON -DANDROID_STL_FORCE_FEATURES=ON -DBUILD_ANDROID_EXAMPLES_WITH_LIBS=OFF -DBUILD_ANDROID_PACKAGE=ON -DBUILD_DOCS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_FAT_JAVA_LIB=ON -DBUILD_JASPER=OFF  -DBUILD_JPEG=OFF  -DBUILD_OPENEXR=OFF  -DBUILD_PACKAGE=OFF  -DBUILD_PERF_TESTS=OFF -DBUILD_PNG=OFF -DBUILD_TBB=OFF -DBUILD_TESTS=OFF -DBUILD_TIFF=OFF -DBUILD_WITH_DEBUG_INFO=OFF -DBUILD_ZLIB=OFF -DBUILD_opencv_androidcamera=OFF -DBUILD_opencv_apps=OFF -DBUILD_opencv_calib3d=OFF -DBUILD_opencv_contrib=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_core=ON -DBUILD_opencv_features2d=OFF -DBUILD_opencv_flann=OFF -DBUILD_opencv_gpu=OFF -DBUILD_opencv_highgui=OFF -DBUILD_opencv_imgproc=ON -DBUILD_opencv_imgcodecs=ON -DBUILD_opencv_legacy=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_nonfree=OFF -DBUILD_opencv_objdetect=OFF -DBUILD_opencv_ocl=OFF -DBUILD_opencv_photo=OFF -DBUILD_opencv_stitching=OFF -DBUILD_opencv_superres=OFF -DBUILD_opencv_ts=OFF -DBUILD_opencv_video=OFF -DBUILD_opencv_videostab=OFF -DBUILD_opencv_world=OFF -DWITH_CUBLAS=OFF -DWITH_CUDA=OFF -DWITH_CUFFT=OFF -DWITH_EIGEN=OFF -DWITH_IPP=OFF -DWITH_JASPER=OFF -DWITH_JPEG=OFF -DWITH_OPENCL=OFF -DWITH_OPENEXR=OFF -DWITH_OPENMP=OFF -DWITH_PNG=OFF -DWITH_TBB=OFF -DWITH_TIFF=OFF ../../opencv  
#  mingw32-make -j5
#  mingw32-make install
#
#  popd
#}

#build_opencv x86
#build_opencv x86_64 
#build_opencv armeabi-v7a
#build_opencv armeabi
#build_opencv arm64-v8a
#build_opencv mips
#build_opencv mips64

# collect install directories to build/install
#cd ..
#mkdir libraries
#pushd libraries
#mkdir x86
#mkdir x86_64 
#mkdir armeabi-v7a
#mkdir armeabi
#mkdir arm64-v8a
#mkdir mips
#mkdir mips64
#popd

#copy_library x86
#copy_library x86_64 
#copy_library armeabi-v7a
#copy_library armeabi
#copy_library arm64-v8a
#copy_library mips
#copy_library mips64
