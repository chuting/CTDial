#
# Be sure to run `pod lib lint CTDial.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CTDial'
  s.version          = '0.1.0'
  s.summary          = '这是一个刻度盘'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
     这是一个刻度盘，支持设置当前值，最大最小值，支持响应用户手势滑动指针修改值
                       DESC

  s.homepage         = 'https://github.com/chuting/CTDial'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '502353919@qq.com' => '502353919@qq.com' }
  s.source           = { :git => 'https://github.com/chuting/CTDial.git' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CTDial/Classes/**/*'
  s.resources =   ['CTDial/Assets/*.xcassets']
  # s.resource_bundles = {
  #   'CTDial' => ['CTDial/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
