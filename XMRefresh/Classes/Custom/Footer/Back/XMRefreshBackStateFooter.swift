//
//  XMRefreshBackStateFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshBackStateFooter: XMRefreshBackFooter {

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
    public override func prepare() {
        super.prepare()
        set(title: Bundle.xm_localizedString(key: XMRefreshBackFooterIdleText), state: .idle)
        set(title: Bundle.xm_localizedString(key: XMRefreshBackFooterPullingText), state: .pulling)
        set(title: Bundle.xm_localizedString(key: XMRefreshBackFooterRefreshingText), state: .refreshing)
        set(title: Bundle.xm_localizedString(key: XMRefreshBackFooterNoMoreDataText), state: .noMoreData)
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
        stateLabel.text = stateTitles[newState]
    }



}
