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

    var asset: AVAsset!
    
    var startPoint: CGPoint!
    var startTime: CGFloat!
    var endTime: CGFloat!
    var widthPerSecond: CGFloat!
    var imageGenerator: AVAssetImageGenerator!
    
    var cropImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        
        var picWidth: CGFloat?
        var halfWayImage: CGImageRef?
        var videoScreen: UIImage?
//        var actualTime: CMTime!
        do {
            halfWayImage = try imageGenerator.copyCGImageAtTime(kCMTimeZero, actualTime: nil)
        } catch let e {
            debugPrint("\(e)")
            halfWayImage = nil
        }
        guard let halfImage = halfWayImage else {
            debugPrint("halfWayImage is nil")
            return
        }
        videoScreen = UIImage(CGImage: halfImage, scale: 1.0, orientation: .Up)
        let tmp = UIImageView(image: videoScreen)
        var rect = tmp.frame
        rect.size.width = videoScreen!.size.width
        tmp.frame = rect
        addSubview(tmp)
        picWidth = tmp.frame.size.width
}
    
    func cropImageViewPan(pan: UIPanGestureRecognizer) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
