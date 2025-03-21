#
# Be sure to run `pod lib lint SFSymbolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SFSymbolKit'
  s.version          = '0.2.1'
  s.summary          = 'Use SFSymbol on iOS9+.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Export symbol svg file from SFSymbol app, and use it on iOS device.
                       DESC

  s.homepage         = 'https://github.com/Magic-Unique/SFSymbolKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '冷秋' => '516563564@qq.com' }
  s.source           = { :git => 'https://github.com/Magic-Unique/SFSymbolKit.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'SFSymbolKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SFSymbolKit' => ['SFSymbolKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
