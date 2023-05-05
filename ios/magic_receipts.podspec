#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint magic_receipts.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'magic_receipts'
  s.version          = '1.0.1'
  s.summary          = 'Magic Receipts Flutter iOS Module'
  s.description      = <<-DESC
A  Flutter plugin for rendering Magic Receipts wall within an app
                       DESC
  s.homepage         = 'http://pollfish.com/magic-receipts'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pollfish, Inc.' => 'support@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'MagicReceipts', '~> 1.0.0'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
