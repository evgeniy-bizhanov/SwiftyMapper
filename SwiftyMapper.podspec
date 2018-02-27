#
# Be sure to run `pod lib lint SwiftyMapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftyMapper'
  s.version          = '0.1.0'
  s.summary          = 'n-layer architectures Model-DTO-Model mapper'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This CocoaPod provides the ability to map data transfering between layers
                       DESC

  s.homepage         = 'https://github.com/evgeniy-bizhanov/SwiftyMapper'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'evgeniy-bizhanov' => 'evgeniy.bizhanov@me.com' }
  s.source           = { :git => 'https://github.com/evgeniy-bizhanov/SwiftyMapper.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/evgeniybizhanov'
  s.social_media_url = 'https://vk.com/evgeniybizhanov'

  s.ios.deployment_target = '8.0'
  
  s.swift_version = '4.1'

  s.source_files = 'SwiftyMapper/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SwiftyMapper' => ['SwiftyMapper/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
