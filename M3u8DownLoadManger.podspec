#
# Be sure to run `pod lib lint M3u8DownLoadManger-Swift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'M3u8DownLoadManger'
  s.version          = '0.0.1'
  s.summary          = '通过缓存预下载m3u8首段 ts,达到抖音级别滑动视频切换流畅度'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: 通过预下载 ts 到本地,播放器播放本地第一段优化切换播放流畅度 ,其他段通过重定向技术播放服务器端 ts段b完美避开网络缓存拼接问题.同时感谢GCDWebServer提供的开源支持(重定向核心) 如果有帮助给个星❤
                       DESC

  s.homepage         = 'https://github.com/1241545546/M3u8DownLoadManger-Swift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wusa' => '1241545546@qq.com' }
  s.source           = { :git => 'https://github.com/1241545546/M3u8DownLoadManger-Swift.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'M3u8DownLoadManger/Classes/**/*'
  
  # s.resource_bundles = {
  #   'M3u8DownLoadManger-Swift' => ['M3u8DownLoadManger-Swift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency "GCDWebServer/WebDAV", "~> 3.0"
   s.dependency "AFNetworking"
   s.dependency "YYCache"
   
end
