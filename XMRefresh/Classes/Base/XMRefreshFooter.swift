//
//  XMRefreshFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshFooter: XMRefreshComponent {

    /// 提示没有更多的数据
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {
            self.state = .noMoreData
        }
    }

    /// 重置没有更多的数据（消除没有更多数据的状态
    public func resetNoMoreData() {
        DispatchQueue.main.async {
            self.state = .idle
        }
    }
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0.0
    public override func prepare() {
        super.prepare()
        xm_height = XMRefreshFooterHeight
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
    }


}
