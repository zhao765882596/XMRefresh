//
//  XMRefreshBackStateFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

class XMRefreshBackStateFooter: XMRefreshBackFooter {

    private var _stateLabel = UILabel.xm_label
    private var stateTitles: Dictionary <XMRefreshState,String> = [:]

    public var labelLeftInset: CGFloat = XMRefreshLabelLeftInset

    public var stateLabel: UILabel {
        if _stateLabel.superview == nil {
            addSubview(_stateLabel)
        }
        return _stateLabel
    }
    public func set(title: String?, state: XMRefreshState) {
        if title == nil {
            return
        }
        stateTitles[state] = title ?? ""
        _stateLabel.text = stateTitles[self.state]
    }
    public var isRefreshingTitleHidden = false
    
    @objc func stateLabelClick() {
        if state == .idle {
            beginRefreshing()
        }
    }
    public override func prepare() {
        super.prepare()
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterIdleText), state: .idle)
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterRefreshingText), state: .refreshing)
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterNoMoreDataText), state: .noMoreData)
        stateLabel.isUserInteractionEnabled =  true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.stateLabelClick)))
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.constraints.count == 0 {
            return
        }
        stateLabel.frame = bounds
    }
    public override func set(oldState: XMRefreshState) {
        if state == oldState {
            return
        }
        super.set(oldState: oldState)
        if isRefreshingTitleHidden && state == .refreshing {
            stateLabel.text = nil
        } else {
            stateLabel.text = stateTitles[state]
        }
    }



}
