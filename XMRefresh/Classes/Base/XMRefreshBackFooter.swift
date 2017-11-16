//
//  XMRefreshBackFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshBackFooter: XMRefreshFooter {
    var lastBottomDelta: CGFloat = 0.0
    var lastRefreshCount = 0


    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        scrollViewContentSizeDidChange(Change: nil)
    }
    override public func scrollViewContentOffsetDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewContentOffsetDidChange(Change: Change)
        if state == .refreshing {
            return
        }
        guard let scroll = scrollView else { return }

        scrollViewOriginalInset = scroll.xm_inset
        let currentOffsetY = scroll.xm_offsetY
        let happenY = happenOffsetY()
        if currentOffsetY <= happenY {
            return
        }
        let pullingPercent = (currentOffsetY - happenY) / xm_height
        if state == .noMoreData {
            self.pullingPercent = pullingPercent
            return
        }
        if scroll.isDragging {
            self.pullingPercent = pullingPercent
            let normal2pullingOffsetY = happenY + xm_height
            if state == .idle && currentOffsetY > normal2pullingOffsetY {
                state = .pulling
            } else if state == .pulling && currentOffsetY <= normal2pullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1.0 {
            self.pullingPercent = pullingPercent
        }
    }
    public override func scrollViewContentSizeDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewContentSizeDidChange(Change: Change)
        guard let scroll = scrollView else { return }
        let contentHeight = scroll.xm_contentH + ignoredScrollViewContentInsetBottom
        let scrollHeight = scroll.xm_height - scrollViewOriginalInset.top - scrollViewOriginalInset.bottom + ignoredScrollViewContentInsetBottom
        xm_y = max(contentHeight, scrollHeight)
    }
    override public func set(oldState: XMRefreshState) {
        if state == oldState {
            return
        }
        super.set(oldState: oldState)
        guard let scroll = scrollView else { return }
        if state == .noMoreData || state == .idle {
            UIView.animate(withDuration: XMRefreshSlowAnimationDuration, animations: {
                scroll.xm_insetB = scroll.xm_insetB - self.lastBottomDelta
                if self.isAutomaticallyChangeAlpha {
                    self.alpha = 1.0
                }
            }, completion: { (isFinished) in
                self.pullingPercent = 0.0
                if self.endRefreshingCompletion != nil {
                    self.endRefreshingCompletion!()
                }
            })
            let deltaH = self.heightForContentBreakView()
            if oldState == .refreshing && deltaH > 0.0 && scroll.xm_totalDataCount != self.lastRefreshCount {
                self.scrollView?.xm_offsetY = scroll.xm_offsetY
            }
        } else if state == .refreshing {
            lastRefreshCount = scroll.xm_totalDataCount
            UIView.animate(withDuration: XMRefreshFastAnimationDuration, animations: {
                var bottom = self.xm_height + self.scrollViewOriginalInset.bottom
                let deltaH = self.heightForContentBreakView()
                if deltaH < 0 {
                    bottom = bottom - deltaH
                }
                self.lastBottomDelta = bottom - scroll.xm_insetB
                scroll.xm_insetB = bottom
                scroll.xm_offsetY = self.happenOffsetY() + self.xm_height
            }, completion: { (isFinished) in
                self.executeRefreshingCallback()
            })
        }

    }

    func happenOffsetY() -> CGFloat {
        let deltaH = heightForContentBreakView()
        if deltaH > 0 {
            return deltaH - scrollViewOriginalInset.top
        } else {
            return -scrollViewOriginalInset.top
        }
    }
    func heightForContentBreakView() -> CGFloat {
        guard let scroll = scrollView else { return 0.0 }
        let h = scroll.xm_height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        return scroll.contentSize.height  - h
    }
    


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
