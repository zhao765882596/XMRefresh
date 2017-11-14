//
//  UIView_Refresh.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    var xm_x: CGFloat {
        set {
            frame.origin.x = newValue
        }

        get {
            return frame.origin.x
        }
    }

    var xm_origin: CGPoint {
        set {
            frame.origin = newValue
        }

        get {
            return frame.origin
        }
    }

    var xm_size: CGSize {
        set {
            frame.size = newValue
        }

        get {
            return frame.size
        }
    }


    var xm_y: CGFloat {
        set {
            frame.origin.y = newValue
        }

        get {
            return frame.origin.y
        }
    }

    var xm_width: CGFloat {
        set {
            frame.size.width = newValue
        }

        get {
            return frame.size.width
        }
    }
    var xm_height: CGFloat {
        set {
            frame.size.height = newValue
        }

        get {
            return frame.size.height
        }
    }
}

