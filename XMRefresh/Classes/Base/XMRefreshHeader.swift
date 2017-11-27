//
//  XMRefreshHeader.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshHeader: XMRefreshComponent {

    /// 这个key用来存储上一次下拉刷新成功的时间
    public var lastUpdatedTimeKey = ""

    /// 上一次下拉刷新成功的时间
    public var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }

    /// 忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0.0
    private var insetTDelta: CGFloat = 0.0

    public override func prepare() {
        super.prepare()
        lastUpdatedTimeKey = XMRefreshHeaderLastUpdatedTimeKey
        xm_height = XMRefreshHeaderHeight
    }
    public override func placeSubviews() {
        super.placeSubviews()
        xm_y = 0 - xm_height - ignoredScrollViewContentInsetTop
    }
    public override func set(newState: XMRefreshState) {
        let oldState = state
        if oldState == newState {
            return
        }
        super.set(newState: newState)
        guard let scroll = self.scrollView else { return }
        if newState == .idle {
            if oldState != .refreshing {
                return
            }
            UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
            UserDefaults.standard.synchronize()
            UIView.animate(withDuration: XMRefreshFastAnimationDuration, animations: {
                scroll.xm_insetT = scroll.xm_insetT + self.insetTDelta
                if self.isAutomaticallyChangeAlpha {
                    self.alpha = 0.8
                }
            }, completion: { (isFinished) in
                self.pullingPercent = 0.0
                if self.endRefreshingCompletion != nil {
                    self.endRefreshingCompletion!()
                }
            })
        } else if newState == .refreshing {
            DispatchQueue.main.async {
                UIView.animate(withDuration: XMRefreshFastAnimationDuration, animations: {
                    let top = self.scrollViewOriginalInset.top  + self.xm_height;
                    // 增加滚动区域top
                    scroll.xm_insetT = top;
                    // 设置滚动位置
                    var offset = scroll.contentOffset
                    offset.y = -top;
                    scroll.setContentOffset(offset, animated: false)
                }, completion: { (isFinished) in
                    self.executeRefreshingCallback()
                })
            }
        }
    }
    public override func scrollViewContentOffsetDidChange(Change: Dictionary<AnyHashable, Any>?) {
        super.scrollViewContentOffsetDidChange(Change: Change)
        guard let scroll = self.scrollView else { return }
        if state == .refreshing {
//            if self.window == nil {
//                return
//            }
            var insetT = (-scroll.xm_offsetY > scrollViewOriginalInset.top) ? -scroll.xm_offsetY : scrollViewOriginalInset.top
            insetT = insetT > (xm_height + scrollViewOriginalInset.top) ? xm_height + scrollViewOriginalInset.top : insetT
            scroll.xm_insetT = insetT
            insetTDelta = scrollViewOriginalInset.top - insetT
            return
        }
        scrollViewOriginalInset = scroll.xm_inset
        let offsetY = scroll.xm_offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        if offsetY > happenOffsetY {
            return
        }
        let normal2pullingOffsetY = happenOffsetY - xm_height
        let pullingPercent = (happenOffsetY - offsetY) / xm_height
        if scroll.isDragging {
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < normal2pullingOffsetY {
                state = .pulling
            } else if state == .pulling && offsetY >= normal2pullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1.0 {
            self.pullingPercent = pullingPercent
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

