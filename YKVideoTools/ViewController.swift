//
//  ViewController.swift
//  YKVideoTools
//
//  Created by Youngkook on 16/6/27.
//  Copyright © 2016年 youngkook. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController {
    
    var tempVideoPath: String?
    var videoPlayer: UIView!
    var videoLayer: UIView!
    var save: UIButton!
    
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    var playerLayer: AVPlayerLayer!
    var videoPlaybackPosition: CGFloat!
    var exportSession: AVAssetExportSession!
    var asset: AVAsset!
    var startTime: CGFloat!
    var stopTime: CGFloat!
    
    var isPlaying: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectVideo = UIButton(frame: CGRect(x: 0, y: 50, width: view.width, height: 40))
        selectVideo.setTitle("selet video", forState: .Normal)
        selectVideo.setTitleColor(UIColor.blackColor(), forState: .Normal)
        selectVideo.addTarget(self, action: #selector(ViewController.tapSelectVideo(_:)), forControlEvents: .TouchUpInside)
        view.addSubview(selectVideo)
        
        videoPlayer = UIView(frame: CGRect(x: 0, y: selectVideo.bottom + 20, width: view.width, height: 300))
        videoPlayer.backgroundColor = UIColor.blackColor()
        view.addSubview(videoPlayer)
        
        videoLayer = UIView(frame: videoPlayer.bounds)
        videoPlayer.addSubview(videoLayer)
        
        tempVideoPath = NSTemporaryDirectory().stringByAppendingString("tempMov.mov")
    }

    func tapSelectVideo(sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .PhotoLibrary
        vc.mediaTypes = [kUTTypeMovie as String]
        vc.delegate = self
        vc.editing = false
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func tapVideoLayer(sender: UITapGestureRecognizer) {
        if isPlaying {
            player.pause()
        } else {
            player.play()
        }
        isPlaying = !isPlaying
    }
    
    override func viewDidLayoutSubviews() {
        if playerLayer != nil {
            playerLayer.frame = CGRect(x: 0, y: 0, width: videoLayer.width, height: videoLayer.height)
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        guard let url = info[UIImagePickerControllerMediaURL] as? NSURL else { return }
        
        asset = AVAsset(URL: url)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect
        player.actionAtItemEnd = .None
        videoLayer.layer.addSublayer(playerLayer)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapVideoLayer(_:)))
        videoLayer.addGestureRecognizer(tap)
        
        videoPlaybackPosition = 0
        
        self.tapVideoLayer(tap)
        
        
    }
}

