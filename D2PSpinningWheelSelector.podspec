#
# Be sure to run `pod lib lint D2PSpinningWheelSelector.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'D2PSpinningWheelSelector'
  s.version          = '1.0.0'
  s.summary          = 'An elegant modal selector'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
An elegant modal selector for iPhone using UICollectionView
                DESC

  s.homepage         = 'https://github.com/di2pra/D2PSpinningWheelSelector'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'di2pra' => 'pas495@gmail.com' }
  s.source           = { :git => 'https://github.com/di2pra/D2PSpinningWheelSelector.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/di2pra'

  s.ios.deployment_target = '9.0'

  s.source_files = 'D2PSpinningWheelSelector/Classes/**/*'
  s.resource = 'D2PSpinningWheelSelector/Assets/*.{xcassets}'
  
  s.swift_version = '4.0'
  
  # s.resource_bundles = {
  #   'D2PSpinningWheelSelector' => ['D2PSpinningWheelSelector/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
