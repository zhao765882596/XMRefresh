//
//  XMRefreshGifHeader.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshGifHeader: XMRefreshStateHeader {
    private var _gifView = UIImageView()
    private var stateImages: Dictionary <XMRefreshState,Array<UIImage>> = [:]
    private var stateDurations: Dictionary <XMRefreshState,TimeInterval> = [:]


    public var gifView: UIImageView {
        if _gifView.superview == nil {
            addSubview(_gifView)
        }
        return _gifView
    }
    func set(images: Array<UIImage>?, duration: TimeInterval = 0.0, state: XMRefreshState) {
        if images == nil || images?.count == 0 {
            return
        }
        stateImages[state] = images!
        if duration == 0.0 {
            stateDurations[state] = TimeInterval(images!.count) * 0.1
        } else {
            stateDurations[state] = duration
        }
        let image = images![0]
        if image.size.height > xm_height {
            xm_height = image.size.height
        }
    }
    public override func prepare() {
        labelLeftInset = 20
    }
    public override var pullingPercent: CGFloat {
        didSet {
            super.pullingPercent = oldValue
            let images = stateImages[.idle] ?? []

            if state != .idle || images.count == 0 {
                return
            }
            gifView.stopAnimating()
            var index = Int(CGFloat(images.count) * pullingPercent)
            if index >= images.count {
                index = images.count - 1
            }
            gifView.image = images[index]
        }
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if gifView.constraints.count > 0 {
            return
        }
        gifView.frame = bounds
        if stateLabel.isHidden && lastUpdatedTimeLabel.isHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .right
            let stateWidth = stateLabel.xm_textWith()
            var timeWidth = CGFloat()
            if lastUpdatedTimeLabel.isHidden == false {
                timeWidth = lastUpdatedTimeLabel.xm_textWith()
            }
            let textWidth = max(stateWidth, timeWidth)
            gifView.xm_width = xm_width * 0.5 - textWidth * 0.5 - labelLeftInset
        }
    }
    public override func set(newState: XMRefreshState) {
        let oldState = state
        if oldState == newState {
            return
        }
        super.set(newState: newState)
        if newState == .pulling || newState == .refreshing {
            let images = stateImages[state]
            if images == nil || images?.count == 0 {
                return
            }
            gifView.stopAnimating()
            if images?.count == 1 {
                gifView.image = images?.first
            } else {
                gifView.animationImages = images
                let duration = stateDurations[state] ?? 0.0 > 0.0 ? stateDurations[state] ?? 0.2 : TimeInterval(images!.count) * 0.1
                gifView.animationDuration = duration
                gifView.startAnimating()
            }

        } else if newState == .idle {
            gifView.stopAnimating()
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
