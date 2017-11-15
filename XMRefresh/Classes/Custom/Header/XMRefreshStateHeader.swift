//
//  XMRefreshStateHeader.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshStateHeader: XMRefreshHeader {
    private var _stateLabel = UILabel.xm_label
    private var _lastUpdatedTimeText = UILabel.xm_label
    private var stateTitles: Dictionary <XMRefreshState,String> = [:]

    public var lastUpdatedTimeText: ((Date?) -> String)?

    public var lastUpdatedTimeLabel: UILabel {
        if _lastUpdatedTimeText.superview == nil {
            addSubview(_lastUpdatedTimeText)
        }
        return _lastUpdatedTimeText
    }

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
    public override func set(oldState: XMRefreshState) {
        if state == oldState {
            return
        }
        super.set(oldState: oldState)
        _stateLabel.text = stateTitles[self.state]
        lastUpdatedTimeKey = (lastUpdatedTimeKey.isEmpty ? "" : lastUpdatedTimeKey)

    }
    public override var lastUpdatedTimeKey: String {
        didSet {
            super.lastUpdatedTimeKey = lastUpdatedTimeKey
            if lastUpdatedTimeLabel.isHidden {
                return
            }
            let date = UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
            if lastUpdatedTimeText != nil {
                lastUpdatedTimeLabel.text = lastUpdatedTimeText!(date)
                return
            }
            if date != nil {
                let calendar = Calendar.current
                let cmp1 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date!)
                let cmp2 = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
                let formatter = DateFormatter()
                var isToday = false

                if cmp1.day == cmp2.day {
                    formatter.dateFormat = " HH:mm"
                    isToday = true
                } else if cmp1.year == cmp2.year {
                    formatter.dateFormat = "MM-dd HH:mm"
                } else {
                    formatter.dateFormat = "yyyy-MM-dd HH:mm";
                }
                let timeStr = formatter.string(from: date!)
                lastUpdatedTimeLabel.text = String.init(format: "%@%@%@", Bundle.xm_localizedString(key: XMRefreshHeaderLastTimeText), isToday ? Bundle.xm_localizedString(key: XMRefreshHeaderDateTodayText) : "", timeStr)
            } else {
               lastUpdatedTimeLabel.text = String.init(format: "%@%@", Bundle.xm_localizedString(key: XMRefreshHeaderLastTimeText), Bundle.xm_localizedString(key: XMRefreshHeaderNoneLastDateText))
            }
        }
    }
    public override func prepare() {
        super.prepare()
        labelLeftInset = XMRefreshLabelLeftInset
        set(title: Bundle.xm_localizedString(key: XMRefreshHeaderIdleText), state: .idle)
        set(title: Bundle.xm_localizedString(key: XMRefreshHeaderPullingText), state: .pulling)
        set(title: Bundle.xm_localizedString(key: XMRefreshHeaderRefreshingText), state: .refreshing)
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if stateLabel.isHighlighted {
            return
        }
        let noConstrainsOnStatusLabel = stateLabel.constraints.count == 0
        if lastUpdatedTimeLabel.isHidden {
            if noConstrainsOnStatusLabel {
                stateLabel.frame = bounds
            }
        } else {
            let stateLabelH = xm_height * 0.5
            if noConstrainsOnStatusLabel {
                stateLabel.frame = CGRect.init(x: 0, y: 0, width: xm_width, height: stateLabelH)
            }
            if lastUpdatedTimeLabel.constraints.count == 0 {
                lastUpdatedTimeLabel.frame = CGRect.init(x: 0, y: stateLabelH, width: xm_width, height: stateLabelH)
            }
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
