//
//  XMRefreshAutoStateFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshAutoStateFooter: XMRefreshAutoFooter {
    public var labelLeftInset: CGFloat = XMRefreshLabelLeftInset
    private var _stateLabel: UILabel  = UILabel.xm_label
    private var stateTitles: Dictionary <XMRefreshState,String> = [:]


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
    @objc func stateLabelClick() {
        if state == .idle {
            beginRefreshing()
        }
    }
    public var isRefreshingTitleHidden = false

    public override func prepare() {
        super.prepare()
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterIdleText), state: .idle)
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterRefreshingText), state: .refreshing)
        set(title: Bundle.xm_localizedString(key: XMRefreshAutoFooterNoMoreDataText), state: .noMoreData)
        stateLabel.isUserInteractionEnabled = true
        stateLabel.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(self.stateLabelClick)))
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.constraints.count == 0 {
            stateLabel.frame = bounds
        }
    }
    public override func set(newState: XMRefreshState) {
        let oldState = state
        if oldState == newState {
            return
        }
        super.set(newState: newState)
        if isRefreshingTitleHidden && newState == .refreshing {
            stateLabel.text = nil
        } else {
            stateLabel.text = stateTitles[newState]
        }
    }







}
