# M3u8DownLoadManger

[![CI Status](https://img.shields.io/travis/DuoLa/M3u8DownLoadManger.svg?style=flat)](https://travis-ci.org/DuoLa/M3u8DownLoadManger)
[![Version](https://img.shields.io/cocoapods/v/M3u8DownLoadManger.svg?style=flat)](https://cocoapods.org/pods/M3u8DownLoadManger)
[![License](https://img.shields.io/cocoapods/l/M3u8DownLoadManger.svg?style=flat)](https://cocoapods.org/pods/M3u8DownLoadManger)
[![Platform](https://img.shields.io/cocoapods/p/M3u8DownLoadManger.svg?style=flat)](https://cocoapods.org/pods/M3u8DownLoadManger)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

//1.启动服务器
M3u8Cache.startListenService()
//2. 预下载
M3u8DownLoad.manger.downLoadProTs(url: "http://vcache.city84.com/video/c110477/audio/6a9b7675f34e4c0d86acaae70c1befba.m3u8")
//3.映射后的播放地址 丢给播放器播放
let lurl = M3u8Cache.proxyLocal(url: "http://vcache.city84.com/video/c110477/audio/6a9b7675f34e4c0d86acaae70c1befba.m3u8")
//播放器播放
play(lurl)
## Requirements

## Installation

M3u8DownLoadManger is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'M3u8DownLoadManger'
```

## Author

wusa, '1241545546@qq.com'

## License

M3u8DownLoadManger is available under the MIT license. See the LICENSE file for more info.
