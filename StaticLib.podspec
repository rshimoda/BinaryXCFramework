Pod::Spec.new do |s|
  s.name                    = 'StaticLib'
  s.version                 = '1.0.0'

  s.summary                 = 'Sample Pod containing an XCFramework with a set of static libraries.'

  s.author                  = 'Serhii Popov'
  s.homepage                = 'https://github.com/rshimoda'
  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => "https://github.com/rshimoda/StaticLib.git", :tag => s.version }

  s.swift_version           = '5.6'
  s.requires_arc            = true

  s.ios.deployment_target   = '12.0'
  s.ios.frameworks          = 'Security', 'UIKit', 'Security'

  s.osx.deployment_target   = '10.14'
  s.osx.frameworks          = 'Security', 'AppKit', 'Security'

  s.vendored_frameworks     = 'StaticLib.xcframework'
  s.static_framework        = true

  s.pod_target_xcconfig     = {
    'CODE_SIGNING_ALLOWED'    => 'NO'
  }

  s.user_target_xcconfig    = {
    'OTHER_LDFLAGS'           => "-force_load \"$(PODS_XCFRAMEWORKS_BUILD_DIR)/StaticLib/libStaticLib.a\"",
    'SWIFT_INCLUDE_PATHS'     => '$(PODS_XCFRAMEWORKS_BUILD_DIR)/StaticLib',
    'LD_RUNPATH_SEARCH_PATHS' => '/usr/lib/swift'
  }
  
end
