# CocoaPods x Xcode 15 Issue Sample
This is a sample project to show an issue with a Pod integration in Xcode 15. 

## Desription
In this repository there're 3 main components:
- **StaticLib** and **StaticLib.xcframework**: a simple static library and script to build an XCFramework. The built `StaticLib.xcframework` is also present.
- **StaticLib.podspec**: a Podspec containing information about a Pod.
- **SampleApp**: a SwiftUI application that has StaticLib.xcframework dependency.

### StaticLib
This is a static library containuing a single class with a single static property. The library itself plays a placeholder role for Pod and SampleApp.
By the legend, StaticLib requires to be loaded as early as possible, so a '-force_load $(BUILT_PRODUCTS_DIR)/libStaticLib.a' is needed in 'Other Linker Flags'.

### StaticLib.podspec
This podspec describes a simple Pod containing a XCFramework. It also contains a custom `OTHER_LDFLAGS` entry (which actually causes a problem), required for the library.

### SampleApp
This is a simple SwiftUI application, that has StaticLib as a dependency.
There're 2 targets: SampleApp (has the xcframework added manually) and SampleApp-Pods (which uses StaticLib pod).

## How to use this project
1. Run `pod install`, open the generated `.xcworkspace`.
2. Select 'SampleApp' target, build and run. You should see an application displayiing 'Hello, Foo' text.
3. Select 'SampleApp-Pods' target. Try to build - you should get an error.
4. Go to 'Build Phases' section of 'SampleApp-Pods' target, find 'Xcode 15 Workaround' phase.
5. Insert `${PODS_XCFRAMEWORKS_BUILD_DIR}/StaticLib/libStaticLib.a` into 'Output Files' section if this phase.
6. Try building the target. Now it should succeed.
