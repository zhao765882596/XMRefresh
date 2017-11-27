//
//  XMRefreshFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshFooter: XMRefreshComponent {
    private static var dispatch_once = true

    public var isAutomaticallyHidden = false {
        didSet {
            if isAutomaticallyHidden {
                if XMRefreshFooter.dispatch_once  {
                    XMRefreshFooter.dispatch_once = false
                    UITableView.exchangeInstance(method1: #selector(UITableView.reloadData), method2: #selector(UITableView.xm_reloadData))
                    UICollectionView.exchangeInstance(method1: #selector(UITableView.reloadData), method2: #selector(UITableView.xm_reloadData))
                }
            }

        }
    }

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
        if (self.scrollView is UITableView) || (self.scrollView is UICollectionView){
            self.scrollView?.xm_reloadDataBlock = {[weak self] totalDataCount in
                if self?.isAutomaticallyHidden == true {
                    self?.isHidden = totalDataCount == 0
                }
            }

        }
    }


}
private extension UITableView {
    @objc func xm_reloadData() {
        self.xm_reloadData()
        executeReloadDataBlock()
    }
}
private extension UICollectionView {
    @objc func xm_reloadData() {
        self.xm_reloadData()
        executeReloadDataBlock()
    }
}
