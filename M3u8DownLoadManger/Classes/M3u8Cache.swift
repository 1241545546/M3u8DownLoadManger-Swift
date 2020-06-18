//
//  M3u8Cache.swift
//  M3u8DownLoadManger-Swift
//
//  Created by DuoLa on 2020/6/18.
//

import UIKit

import YYCache

import CommonCrypto

import GCDWebServer
///提供缓存管理数据(下载了多少片段)  提供i前台代理 UrL 缓存原始地址以便映射播放后续片段
class M3u8Cache: NSObject {
    
    static let cacheManger = YYCache.init(name: "M3u8CacheStateManger")
    
    static let server = GCDWebServer()
    
    /// 开启本地服务 端口号默认 8979 如需改变请修改代码
    public class func startListenService() -> Void {
        
        server.addDefaultHandler(forMethod: "GET", request: GCDWebServerRequest.self, processBlock: {request in
            
            var url = request.url
            let localpath = "\(NSHomeDirectory())/Documents/M3U8File/\(url.absoluteString.replacingOccurrences(of: "http://localhost:8978/", with: ""))"
            if request.url.absoluteString.contains(".m3u8") && FileManager.default.fileExists(atPath:localpath) {
                do {
                    let string =  try String(contentsOfFile: localpath)
                    return GCDWebServerDataResponse.init(text: string)
                } catch {}
                
            } else if (request.url.absoluteString.contains(".ts")) {
                if request.url.absoluteString.contains("-000.ts") && FileManager.default.fileExists(atPath:localpath) {
                    do {
                        let string =  try Data.init(contentsOf: URL(fileURLWithPath: localpath))
                        return GCDWebServerDataResponse.init(data: string, contentType: "ts")
                    } catch {}
                } else {
                    let splitarrys = url.absoluteString.split(separator: "/")
                    let realurl = M3u8Cache.realTsHost(key: splitarrys[2] as NSString)
                    var tsstrss = realurl.split(separator: "/")
                    tsstrss.removeLast()
                    var mutialts = ""
                    for item in tsstrss.enumerated() {
                        mutialts.append("\(String(item.element))/")
                    }
                    url = URL(string: "\(mutialts)\(url.absoluteString.split(separator: "/").last ?? "")")!
                    debugPrint("重定向 出发\(url.absoluteString)")
                    return GCDWebServerDataResponse.init(redirect: url, permanent: false)
                }
            }
            let urlsplit = url.absoluteString.split(separator: "/")
            let realurl = M3u8Cache.realTsHost(key: urlsplit[2] as NSString)
            if url.absoluteString.contains(".m3u8") {
                return GCDWebServerDataResponse.init(redirect: URL(string: realurl)!, permanent: false)
            } else {
                var tsstrss = realurl.split(separator: "/")
                tsstrss.removeLast()
                var mutialts = ""
                for item in tsstrss.enumerated() {
                    mutialts.append("\(String(item.element))/")
                }
                return GCDWebServerDataResponse.init(redirect: URL(string: "\(mutialts)\(String(urlsplit.last!))")!, permanent: false)
            }
        })

        server.start(withPort: 8978, bonjourName: "M3u8Cache Web Server")
    }
    
    /// 本地 代理  默认端口号8978 如有冲突请修改使用 记得开启服务器
    /// - Parameter url: 原始url
    public class func proxyLocal(url:String) -> URL {
        let string = NSString(string: url)
        self.cacheTsUrl(value: url, key: url)
        return URL(string: "http://localhost:8978/\(url.md5)/\(url.md5).\(string.pathExtension)")!
        
    }
    ///获取真正的服务器主机地址
    class func realTsHost(key:NSString) -> String {
        return cacheManger?.object(forKey: key as String) as? String ?? ""
    }
    ///将m3u8 对应的真正的主机地址缓存起来一遍不同地方获取
    class fileprivate func cacheTsUrl(value:String,key:String) -> Void {
        if !cacheManger!.containsObject(forKey: value) {
            cacheManger?.setObject(value as NSCoding, forKey: key.md5)
        }
    }
}

extension String {
    var md5:String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02x", $1) }
    }
}
