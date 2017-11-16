//
//  XMRefreshBackGifFooter.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshBackGifFooter: XMRefreshBackStateFooter {

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
        super.prepare()
        labelLeftInset = 20
    }
    public override func placeSubviews() {
        super.placeSubviews()
        if gifView.constraints.count > 0 {
            return
        }
        gifView.frame = bounds
        if isRefreshingTitleHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .right
            gifView.xm_width = xm_width * 0.5 - labelLeftInset - stateLabel.xm_textWith() * 0.5
        }
    }
    public override func set(oldState: XMRefreshState) {
        if state == oldState {
            return
        }
        super.set(oldState: oldState)
        if state == .refreshing {
            let images = stateImages[state]
            if images == nil || images?.count == 0 {
                return
            }
            gifView.isHidden = false
            if images?.count == 1 {
                gifView.image = images?.first
            } else {
                gifView.animationImages = images
                let duration = stateDurations[state] ?? 0.0 > 0.0 ? stateDurations[state] ?? 0.2 : TimeInterval(images!.count) * 0.1
                gifView.animationDuration = duration
                gifView.startAnimating()
            }
        } else if state == .noMoreData || state == .idle {
            gifView.stopAnimating()
            gifView.isHidden = true
        }
    }
}
