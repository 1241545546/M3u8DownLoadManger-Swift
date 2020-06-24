//
//  M3u8Decode.swift
//  M3u8DownLoadManger-Swift
//
//  Created by DuoLa on 2020/6/18.
//

import UIKit
/// 只负责解码 m3u8 文件提供 片段下载路径
class M3u8Decode: NSObject {

    /// 解码m3u8 文件返回需要下载的 ts段
    /// - Parameter path: 下载好的 m3u8(副本) 文件路径 会返回所有的 ts 只需要写在第一个即可
    class func decodeM3u8File(path:String) -> [String]? {
        
        if FileManager.default.fileExists(atPath: path) {
            do {
                let m3u8file = try String(contentsOfFile: path)
                let arryres = m3u8file.split(separator: "\n")
                var tsarry = [String]()
                for item in arryres {
                    if item.contains(".ts") {
                        tsarry.append(String(item))
                    }
                }
                return tsarry
            } catch {
                return nil
            }
            
        } else {
            return nil
        }
    }
    
    /// 解码主机服务器地址
    /// - Parameter url:  Url
    class func decodeHost(url:String) -> String {
        
        var result = url.split(separator: "/")
        result.removeLast()
        var host = ""
        for item in result {
            host.append("/\(item)")
        }
        if host.hasPrefix("/") {
            host = String(host.suffix(host.count - 1))
        }
        return host
    }
}
