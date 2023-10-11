#!/bin/sh

#  build.sh
#  BinaryXCFramework
#
#  Created by Сергій Попов on 09.10.2023.
#

echo "Cleaning up"
rm -rf "StaticLib.xcframework"

# Paths to the static libraries
ios_lib="StaticLib-iOS"
macos_lib="StaticLib-macOS"

# Intermediate folders for building the xcframework
build_folder="build"

# Create directories if not exist
echo "Creating temporary directories"
mkdir -p $build_folder

# Derived data for each platform
derived_data_ios="${build_folder}/${ios_lib}"
derived_data_macos="${build_folder}/${macos_lib}"

XCODEBUILD_COMMAND="xcodebuild clean build \
  -project StaticLib.xcodeproj \
  -configuration Release \
  -disableAutomaticPackageResolution \
  CLANG_COVERAGE_MAPPING=NO \
"

# build the iOS and Simulator versions
echo "Building for iOS"
$XCODEBUILD_COMMAND \
  -scheme ${ios_lib} \
  -destination 'generic/platform=iOS' \
  -derivedDataPath "${derived_data_ios}/iOS"

echo "Building for iOS Simulator"
$XCODEBUILD_COMMAND \
    -scheme ${ios_lib} \
    -destination 'generic/platform=iOS Simulator' \
    -derivedDataPath "${derived_data_ios}/iOS-Simulator"

# build the Mac Catalyst version
echo "Building for Mac Catalyst"
$XCODEBUILD_COMMAND \
    -scheme ${ios_lib} \
    -sdk iphoneos \
    -destination 'platform=macOS,variant=Mac Catalyst' \
    -derivedDataPath "${derived_data_macos}/Catalyst"

# build the macOS version
echo "Building for macOS"
$XCODEBUILD_COMMAND \
    -scheme ${macos_lib} \
    -destination 'generic/platform=macOS' \
    -derivedDataPath "${derived_data_macos}/macOS"

# create xcframework
echo "Creating an XCFramework"
#xcodebuild -create-xcframework \
#    -library "${derived_data_ios}/iOS/Build/Products/Release-iphoneos/libStaticLib.a" \
#    -library "${derived_data_ios}/iOS-Simulator/Build/Products/Release-iphonesimulator/libStaticLib.a" \
#    -library "${derived_data_macos}/Catalyst/Build/Products/Release-maccatalyst/libStaticLib.a" \
#    -library "${derived_data_macos}/macOS/Build/Products/Release/libStaticLib.a" \
#    -output "./StaticLib.xcframework"

xcodebuild -create-xcframework \
    -library "${derived_data_ios}/iOS-Simulator/Build/Products/Release-iphonesimulator/libStaticLib.a" \
    -output "./StaticLib.xcframework"

# cleanup
echo "Cleaning up"
rm -rf ${build_folder}
