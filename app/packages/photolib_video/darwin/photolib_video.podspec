Pod::Spec.new do |s|
  s.name             = 'photolib_video'
  s.version          = '0.0.1'
  s.summary          = 'Prototype AVFoundation executor of the M0-35 spike.'
  s.homepage         = 'https://github.com/arxiflex-dev/photolib'
  s.license          = { :type => 'AGPL-3.0-only' }
  s.author           = 'Photolib'
  s.source           = { :path => '.' }
  s.source_files     = 'photolib_video/Sources/photolib_video/**/*.swift'
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
