//
//  YKVideoTrimmer.swift
//  YKVideoTools
//
//  Created by Youngkook on 16/6/27.
//  Copyright © 2016年 youngkook. All rights reserved.
//

import UIKit
import AVFoundation

let imgCount = 8

protocol YKVideoTrimmerDelegate: class {
    func trimmerTime(view: UIView, didChangePoint: CMTime)
}

class YKVideoTrimmer: UIView {
    
    weak var delegate: YKVideoTrimmerDelegate!
    private var _asset: AVAsset?
    var asset: AVAsset! {
        didSet {
            setupSubViews()
        }
    }
    
    var startPoint: CGPoint = CGPointZero
    var startTime: CGFloat!
    var endTime: CGFloat!
    var widthPerSecond: CGFloat!
    var imageGenerator: AVAssetImageGenerator!
    var backView: UIView!
    var cropImageView: UIImageView!
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var videoLayer: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, asset: AVAsset) {
        self.init(frame: frame)
        self.asset = asset
        setupSubViews()
    }
    
    func setupSubViews() {
        self.subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        clipsToBounds = true
        addBackgroundImageView()
    }
    
    func addBackgroundImageView() {
        imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let picWidth: CGFloat = UIScreen.mainScreen().bounds.width / CGFloat(imgCount)
        var halfWayImage: CGImageRef?
        let duration = CMTimeGetSeconds(self.asset.duration)
        let screenWidth = UIScreen.mainScreen().bounds.width
        backView = UIView()
        addSubview(backView)
        backView.frame = CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: CGRectGetWidth(self.frame)))
        let durationPerFrame = duration / Float64(imgCount)
        
        for i in 0..<imgCount {
            let time = CMTimeMakeWithSeconds(Float64(i) * durationPerFrame, 1000)
            do {
                halfWayImage = try imageGenerator.copyCGImageAtTime(time, actualTime: nil)
            } catch let e {
                debugPrint("\(e)")
                halfWayImage = nil
            }
            guard let halfImage = halfWayImage else {
                debugPrint("halfWayImage is nil")
                return
            }
            let imgView = UIImageView()
            imgView.image = UIImage(CGImage: halfImage)
            backView.addSubview(imgView)
            imgView.frame = CGRect(x: CGFloat(i) * picWidth, y: 0, width: picWidth, height: CGRectGetHeight(self.frame))
        }
        
        let coverImageView = UIView()
        backView.addSubview(coverImageView)
        coverImageView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        coverImageView.frame = backView.frame
        
        videoLayer = UIView(frame: CGRect(origin: CGPointZero, size: CGSize(width: self.gg_height, height: self.gg_height)))
        videoLayer.layer.borderWidth = 1
        videoLayer.layer.borderColor = UIColor.yellowColor().CGColor
        backView.addSubview(videoLayer)
        let item = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: item)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: videoLayer.gg_width, height: videoLayer.gg_height)
        playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect
        player.actionAtItemEnd = .None
        videoLayer.layer.addSublayer(playerLayer)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(YKVideoTrimmer.cropImageViewPan(_:)))
        videoLayer.addGestureRecognizer(pan)
    }
    
    func cropImageViewPan(pan: UIPanGestureRecognizer) {
        switch pan.state {
        case .Began:
            startPoint = pan.locationInView(self)
        case .Changed:
            let point = pan.locationInView(self)
            let center = videoLayer.center
            let delX = point.x - startPoint.x
            let newCenter = center.x + delX
            var newMidx = newCenter
            let maxWidth = self.frame.width
            if newMidx + videoLayer.gg_width / 2 > maxWidth {
                newMidx = maxWidth - videoLayer.gg_width / 2
            } else if newMidx - videoLayer.gg_width / 2 < CGRectGetMinX(backView.frame) {
                newMidx = CGRectGetMidX(videoLayer.frame)
            }
            videoLayer.center = CGPoint(x: newMidx, y: videoLayer.center.y)
            startPoint = point
            let videoWidth = maxWidth - videoLayer.gg_width
            let videoPercent = videoLayer.gg_x / videoWidth
            let duration = CMTimeGetSeconds(asset.duration)
            let time = CMTimeMakeWithSeconds(duration * Float64(videoPercent), asset.duration.timescale)   // time/timeScale = s
            self.player.seekToTime(time, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
            if delegate != nil {
                delegate.trimmerTime(backView, didChangePoint: time)
            }
        default: ""
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
