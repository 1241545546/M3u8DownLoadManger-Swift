//
//  ViewController.swift
//  M3u8DownLoadManger
//
//  Created by DuoLa on 06/18/2020.
//  Copyright (c) 2020 DuoLa. All rights reserved.
//

import UIKit

import M3u8DownLoadManger

import ZFPlayer

class ViewController: UIViewController {
    
    lazy var player: ZFPlayerController = {
        var playerss = ZFPlayerController.init(playerManager: ZFAVPlayerManager.init(), containerView: view)
        playerss.assetURL = M3u8Cache.proxyLocal(url: "http://vcache.city84.com/video/c003596/audio/4d2fbe6229df4795accbae3bdc32225c.m3u8")
        return playerss
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        M3u8DownLoad.manger.downLoadProTs(url: "http://vcache.city84.com/video/c003596/audio/4d2fbe6229df4795accbae3bdc32225c.m3u8")
        
        // Do any additional setup after loading the view, typically from a nib.
        player.playTheIndex(0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

