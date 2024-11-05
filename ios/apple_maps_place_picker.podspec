Pod::Spec.new do |s|
    s.name             = 'apple_maps_place_picker'
    s.version          = '0.0.1'
    s.summary          = 'A new Flutter plugin for Apple Maps Place Picker integration'
    s.description      = <<-DESC
  A Flutter plugin that provides a place picker using Apple Maps.
                         DESC
    s.homepage         = 'https://github.com/yourusername/apple_map_kit'
    s.license          = { :file => '../LICENSE' }
    s.author           = { 'Your Company' => 'shahmirzali.dev@gmail.com' }
    s.source           = { :path => '.' }
    s.source_files = 'Classes/**/*'
    s.dependency 'Flutter'
    s.platform = :ios, '15.0'
    s.swift_version = '5.9'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

    s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)' }
  end