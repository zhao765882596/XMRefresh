//
//  XMRefreshAutoFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshAutoFooter: XMRefreshFooter {
    public var isAutomaticallyRefresh = true
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if isHidden == false {
                scrollView?.xm_insetB = scrollView?.xm_insetB ?? 0.0 + xm_height
            }
            xm_y = scrollView?.xm_contentH ?? 0.0
        } else {
            if isHidden == false {
                scrollView?.xm_insetB = scrollView?.xm_insetB ?? 0.0 + xm_height
            }
        }
    }
    public override func prepare() {
        super.prepare()
        triggerAutomaticallyRefreshPercent = 1.0
    }
    public override func scrollViewContentSizeDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewContentSizeDidChange(Change: Change)
        xm_y = scrollView?.xm_contentH ?? 0.0

    }
    public override func scrollViewContentOffsetDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewContentSizeDidChange(Change: Change)
        if state != .idle || !isAutomaticallyRefresh || xm_y == 0 {
            return
        }
        guard let scroll = scrollView else { return }
        if scroll.xm_insetT + scroll.xm_contentH > scroll.xm_height {
            if scroll.xm_offsetY >= scroll.xm_contentH - scroll.xm_height + xm_height * triggerAutomaticallyRefreshPercent + scroll.xm_insetB - xm_height {
                let old = Change?["old"] as? CGPoint
                let new = Change?["new"] as? CGPoint
                if new?.y ?? 0.0 <= old?.y ?? 0.0 {
                    return
                }
                beginRefreshing()
            }
        }
    }
    public override func scrollViewPanStateDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewPanStateDidChange(Change: Change)
        if state != .idle {
            return
        }
        guard let scroll = scrollView else { return }
        if scroll.panGestureRecognizer.state == .ended {
            if scroll.xm_insetT + scroll.xm_contentH <= scroll.xm_height {
                if scroll.xm_offsetY > -scroll.xm_insetT {
                    beginRefreshing()
                }
            } else {
                if scroll.xm_offsetY > scroll.xm_contentH + scroll.xm_insetB - scroll.xm_height {
                    beginRefreshing()
                }
            }
        }
    }
    public override var state: XMRefreshState {
        set {
            let oldState = super.state

            if newValue == oldState {
                return
            }
            super.state = newValue
            if newValue == .refreshing {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                    self.executeRefreshingCallback()
                })
            } else if newValue == .noMoreData || state == .idle {
                if oldState == .refreshing {
                    if self.endRefreshingCompletion != nil {
                        self.endRefreshingCompletion!()
                    }
                }
            }

        }
        get {
            return super.state
        }
    }
    public override var isHidden: Bool {
        set {
            let lastHidden = isHidden
            super.isHidden = newValue
            if !lastHidden  && newValue{
                state = .idle
                scrollView?.xm_insetB = scrollView?.xm_insetB ?? 0.0 - xm_height
            } else if lastHidden && !newValue {
                scrollView?.xm_insetB = scrollView?.xm_insetB ?? 0.0 + xm_height
                xm_y = scrollView?.xm_contentH ?? 0.0
            }
        }
        get {
            return super.isHidden
        }
    }




    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
