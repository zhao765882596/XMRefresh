//
//  XMRefreshAutoNormalFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshAutoNormalFooter: XMRefreshAutoStateFooter {
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            _loadingView = nil
            setNeedsLayout()
        }
    }
    
    private var _loadingView: UIActivityIndicatorView?

    var loadingView:UIActivityIndicatorView {
        if _loadingView == nil {
            _loadingView = UIActivityIndicatorView.init(activityIndicatorStyle: activityIndicatorViewStyle)
            _loadingView?.hidesWhenStopped = true
            addSubview(_loadingView!)
        }
        return _loadingView!
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if loadingView.constraints.count == 0 {
            var loadingCenterX = xm_width * 0.5
            if isRefreshingTitleHidden == false {
                loadingCenterX = loadingCenterX - stateLabel.xm_textWith() * 0.5 - labelLeftInset
            }
            let loadingCenterY = xm_height * 0.5
            loadingView.center = CGPoint.init(x: loadingCenterX, y: loadingCenterY)
        }
    }
    public override func set(oldState: XMRefreshState) {
        if state == oldState {
            return
        }
        super.set(oldState: oldState)
        if state == .noMoreData || state == .idle {
            loadingView.stopAnimating()
        } else if state == .refreshing {
            loadingView.startAnimating()
        }
    }
}
