//
//  CGRect+EX.swift
//  Zhaoshi365
//
//  Created by C on 15/8/28.
//  Copyright (c) 2015年 YoungKook. All rights reserved.
//

import UIKit


extension UIView {
    var gg_x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var gg_y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var gg_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var gg_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var gg_top: CGFloat {
        get {
            return gg_y
        }
        set {
            gg_y = newValue
        }
    }
    
    var gg_bottom: CGFloat {
        get {
            return gg_y + gg_height
        }
    }
    
    var gg_left: CGFloat {
        get {
            return gg_x
        }
    }
    
    var gg_right: CGFloat {
        get {
            return gg_x + gg_width
        }
    }
    
    var gg_midX: CGFloat {
        get {
            return self.gg_x + self.gg_width / 2
        }
    }
    
    var gg_midY: CGFloat {
        get {
            return self.gg_y + self.gg_height / 2
        }
    }
    
    var gg_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var gg_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}
