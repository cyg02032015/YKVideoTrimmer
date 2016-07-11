//
//  YKVideoTrimmer.swift
//  YKVideoTools
//
//  Created by Youngkook on 16/6/27.
//  Copyright © 2016年 youngkook. All rights reserved.
//

import UIKit
import AVFoundation

class YKVideoTrimmer: UIView {

    private var _asset: AVAsset?
    var asset: AVAsset! {
        didSet {
            setupSubViews()
        }
//        set {
//            _asset = newValue
//            setupSubViews()
//        }
//        get {
//            return _asset
//        }
    }
    
    var startPoint: CGPoint!
    var startTime: CGFloat!
    var endTime: CGFloat!
    var widthPerSecond: CGFloat!
    var imageGenerator: AVAssetImageGenerator!
    var backView: UIView!
    var cropImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        setupSubViews()
    }
    
    convenience init(frame: CGRect, asset: AVAsset) {
        self.init(frame: frame)
        self.asset = asset
        setupSubViews()
    }
    
    func setupSubViews() {
        clipsToBounds = true
        
        backgroundColor = UIColor.blackColor()
        addBackgroundImageView()
        cropImageView = UIImageView()
        cropImageView.backgroundColor = UIColor.blueColor()
        cropImageView.userInteractionEnabled = true
        addSubview(cropImageView)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(YKVideoTrimmer.cropImageViewPan(_:)))
        cropImageView.addGestureRecognizer(pan)
    }
    
    func addBackgroundImageView() {
        imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var picWidth: CGFloat = UIScreen.mainScreen().bounds.width / 10
        var halfWayImage: CGImageRef?
        var videoScreen: UIImage?
//        var actualTime: CMTime!
        
        
        let duration = CMTimeGetSeconds(self.asset.duration)
        let screenWidth = UIScreen.mainScreen().bounds.width
        backView = UIView()
        addSubview(backView)
        backView.frame = CGRect(origin: CGPointZero, size: CGSize(width: screenWidth, height: CGRectGetWidth(self.frame)))
        let durationPerFrame = duration / 10
        
        for i in 0..<10 {
            let time = CMTimeMakeWithSeconds(Float64(i * Int(durationPerFrame)), 1000)
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
        
//        videoScreen = UIImage(CGImage: halfImage, scale: 1.0, orientation: .Up)
//        let tmp = UIImageView(image: videoScreen)
//        var rect = tmp.frame
//        rect.size.width = videoScreen!.size.width
//        tmp.frame = rect
//        backView.addSubview(tmp)
//        picWidth = tmp.frame.size.width
        
}
    
    func cropImageViewPan(pan: UIPanGestureRecognizer) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
