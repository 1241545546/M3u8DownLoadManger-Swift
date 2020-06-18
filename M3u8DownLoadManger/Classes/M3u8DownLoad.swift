//
//  M3u8DownLoad.swift
//  M3u8DownLoadManger-Swift
//
//  Created by DuoLa on 2020/6/18.
//

import UIKit

import AFNetworking

///下载提供预下载和全部缓存两个接口 预下载就下载m3u8 和第一个 ts 下载需要取消正在下载的任务执行下载最新的任务 
class M3u8DownLoad: NSObject {
    
    static let manger : M3u8DownLoad = M3u8DownLoad()
        
    lazy var taskList: NSMutableDictionary = {
        var task = NSMutableDictionary()
        return task
    }()
    
    lazy var session: AFURLSessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 8
        var name = AFURLSessionManager(sessionConfiguration: config)
        AFNetworkActivityIndicatorManager.shared().isEnabled = false
        let policy =  AFSecurityPolicy.default()
        policy.allowInvalidCertificates = true
        policy.validatesDomainName = false
        name.securityPolicy = policy
        return name
    }()
    
    let samperor = DispatchSemaphore.init(value: 1)
    
    let gloableQueue = DispatchQueue.global()
    
    ///预下载
    /// - Parameter url: m3u8 的url
    func downLoadProTs(url:String) -> Void {
        
        let fileMd5 = url.md5
        let filePath = "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)/\(fileMd5).m3u8"
        
        if !FileManager.default.fileExists(atPath: "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)") {
            do {
                try FileManager.default.createDirectory(atPath: "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)", withIntermediateDirectories: true, attributes: nil)
            } catch {
                
            }
        }
        
        if FileManager.default.fileExists(atPath: filePath) {
            //存在直接下载
            if let tspath = M3u8Decode.decodeM3u8File(path: filePath) {
                if !FileManager.default.fileExists(atPath: "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)/\(tspath[0])") {
                    self.downLoadTs(url: "\(M3u8Decode.decodeHost(url: url))/\(tspath[0])", dir: "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)", tsname: tspath[0])
                }
            } else {
                debugPrint("msu8 ts路径获取失败")
            }
        } else {
            //下载缓存的路径下
            self.downLoadM3u8(srcurl: url) { (error, res) in
                if error == nil {
                    if let tspath = M3u8Decode.decodeM3u8File(path: filePath) {
                        self.downLoadTs(url: "\(M3u8Decode.decodeHost(url: url))/\(tspath[0])", dir: "\(NSHomeDirectory())/Documents/M3U8File/\(fileMd5)", tsname: tspath[0])
                    } else {
                        debugPrint("msu8 ts路径获取失败")
                    }
                }
            }
        }
    }
    
    func downLoadTs(url:String,dir:String,tsname:String,isall:Bool? = false) -> Void {
        weak var weakSelf = self
        //遍历当前任务 查看是否在任务中
        let keys : [String] = taskList.allKeys as! [String]
        let filter = keys.filter { (key) -> Bool in
            return key == url.md5
        }
        if filter.count != 0 && (taskList.object(forKey: NSString(string: url.md5)) != nil){
            //任务在队列
            let task : URLSessionTask = taskList.object(forKey: NSString(string: url.md5)) as! URLSessionTask
            task.resume()
            return
        }
        
        let task = session.downloadTask(with: URLRequest(url: URL(string: url)!), progress: { (progress) in
            debugPrint("progress\(progress)")
        }, destination: { (url, response) -> URL in
            return URL(fileURLWithPath: "\(dir)/\(tsname)")
        }) { (response, urlss, error) in
            weakSelf!.taskList.removeObject(forKey: url.md5)
        }
        taskList.setObject(task, forKey: NSString(string: url.md5))
        task.resume()
    }
    
    func downLoadM3u8(srcurl:String,handle:@escaping (_ error : Error?,_ response : Any?) -> Void) -> Void {
        //m3u8 下载好之后需要拷贝一份
        let task = session.downloadTask(with: URLRequest(url: URL(string: srcurl)!), progress: { (progress) in
            debugPrint("progress\(progress)")
        }, destination: { (url, response) -> URL in
            return URL(fileURLWithPath: "\(NSHomeDirectory())/Documents/M3U8File/\(srcurl.md5)/\(srcurl.md5)).m3u8")
        }) { (response, url, error) in
            handle(error,response)
        }
        task.resume()
        
        
    }
    
    func canthelAllTask() -> Void {
        for item in taskList.allKeys {
            let key = item as! String
            let task = taskList.object(forKey: key) as! URLSessionTask
            task.cancel()
        }
    }
}
