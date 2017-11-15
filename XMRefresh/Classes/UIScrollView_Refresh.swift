//
//  UIScrollView_Refresh.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC.runtime
extension UIScrollView {
    var xm_inset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        } else {
            return contentInset
        }
    }

    var xm_insetT: CGFloat {
        set {
            if #available(iOS 11.0, *) {
                contentInset.top =  newValue - (adjustedContentInset.top - contentInset.top)
            } else {
                contentInset.top = newValue
            }
        }
        get {
            return xm_inset.top
        }
    }
    var xm_insetB: CGFloat {
        set {
            if #available(iOS 11.0, *) {
                contentInset.bottom =  newValue - (adjustedContentInset.bottom - contentInset.bottom)
            } else {
                contentInset.bottom = newValue
            }
        }
        get {
            return xm_inset.bottom
        }
    }
    var xm_insetL: CGFloat {
        set {
            if #available(iOS 11.0, *) {
                contentInset.left =  newValue - (adjustedContentInset.left - contentInset.left)
            } else {
                contentInset.left = newValue
            }
        }
        get {
            return xm_inset.left
        }
    }
    var xm_insetR: CGFloat {
        set {
            if #available(iOS 11.0, *) {
                contentInset.right =  newValue - (adjustedContentInset.right - contentInset.right)
            } else {
                contentInset.right = newValue
            }
        }
        get {
            return xm_inset.right
        }
    }

    var xm_offsetX: CGFloat {
        set {
            contentOffset.x = newValue
        }
        get {
            return contentOffset.x
        }
    }
    var xm_offsetY: CGFloat {
        set {
            contentOffset.y = newValue
        }
        get {
            return contentOffset.y
        }
    }

    var xm_contentW: CGFloat {
        set {
            contentSize.width = newValue
        }
        get {
            return contentSize.width
        }
    }
    var xm_contentH: CGFloat {
        set {
            contentSize.height = newValue
        }
        get {
            return contentSize.height
        }
    }

}
public extension UIScrollView {
    struct RuntimeKey {
        static let header = UnsafeRawPointer.init(bitPattern: "xm_header".hashValue)
        static let footer = UnsafeRawPointer.init(bitPattern: "xm_footer".hashValue)
//        static let reloadData = UnsafeRawPointer.init(bitPattern: "xm_reloadData".hashValue)
    }

    /// 下拉刷新控件
    public var xm_header: XMRefreshHeader? {
        set {
            self.xm_header?.removeFromSuperview()
            guard let header = newValue else { return }
            insertSubview(header, at: 0)
            willChangeValue(forKey: "xm_header")
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.header!, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "xm_header")
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.header!) as? XMRefreshHeader
        }
    }

    /// 上拉刷新控件
    public var xm_footer: XMRefreshFooter? {
        set {
            self.xm_footer?.removeFromSuperview()
            guard let footer = newValue else { return }
            insertSubview(footer, at: 0)
            willChangeValue(forKey: "xm_footer")
            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.footer!, footer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "xm_footer")
        }
        get {
            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.footer!) as? XMRefreshFooter
        }
    }
    public var xm_totalDataCount: Int {
        var totalCount = 0
        if self is UITableView {
            let tableview = self as! UITableView
            for i in 0 ..< tableview.numberOfSections {
                totalCount = totalCount + tableview.numberOfRows(inSection: i)
            }
        } else if self is UICollectionView {
            let collectionView = self as! UICollectionView
            for i in 0 ..< collectionView.numberOfSections {
                totalCount = totalCount + collectionView.numberOfItems(inSection: i)
            }
        }
        return totalCount
    }

}

//fileprivate extension UIScrollView {
//    class func exchangeInstance(method1: Selector, method2:Selector) {
//        guard let m1 = class_getInstanceMethod(self, method1) else { return }
//        guard let m2 = class_getInstanceMethod(self, method2) else { return }
//        method_exchangeImplementations(m1, m2)
//    }
//    class func exchangeClass(method1: Selector, method2:Selector) {
//        guard let m1 = class_getClassMethod(self, method1) else { return }
//        guard let m2 = class_getClassMethod(self, method2) else { return }
//        method_exchangeImplementations(m1, m2)
//    }
//}

//    public var xm_reloadData: ((Int) -> Void)? {
//        set {
//            willChangeValue(forKey: "xm_reloadData")
//            objc_setAssociatedObject(self, UIScrollView.RuntimeKey.footer!, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//            didChangeValue(forKey: "xm_reloadData")
//        }
//        get {
//            return objc_getAssociatedObject(self, UIScrollView.RuntimeKey.reloadData!) as? ((Int) -> Void)
//        }
//
//    }

//extension UITableView {
//
//
//
//}









