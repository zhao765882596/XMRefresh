//
//  XMRefreshNormalHeader.swift
//  XMRefresh
//
//  Created by ming on 2017/11/14.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import UIKit

public class XMRefreshNormalHeader: XMRefreshStateHeader {
    private var _arrowView = UIImageView()
    private var _loadingView: UIActivityIndicatorView?
    
    public var arrowView: UIImageView {
        if _arrowView.superview == nil {
            _arrowView.image = Bundle.xm_arrowImage()
            addSubview(_arrowView)
        }
        return _arrowView
    }
    var loadingView:UIActivityIndicatorView {
        if _loadingView == nil {
            _loadingView = UIActivityIndicatorView.init(activityIndicatorStyle: activityIndicatorViewStyle)
            _loadingView?.hidesWhenStopped = true
            addSubview(_loadingView!)
        }
        return _loadingView!
    }
    
    public var activityIndicatorViewStyle: UIActivityIndicatorViewStyle = .gray {
        didSet {
            _loadingView = nil
            setNeedsLayout()
        }
    }
    public override func placeSubviews() {
        super.placeSubviews()
        var arrowCenterX = xm_width * 0.5
        if stateLabel.isHighlighted == false {
            let stateWidth = stateLabel.xm_textWith()
            var timeWidth = CGFloat()
            if lastUpdatedTimeLabel.isHidden == false {
                timeWidth = lastUpdatedTimeLabel.xm_textWith()
            }
            let textWidh = max(stateWidth, timeWidth)
            arrowCenterX = arrowCenterX - textWidh * 0.5 - labelLeftInset
        }
        let arrowCenterY = xm_height * 0.5
        let arrowCenter = CGPoint.init(x: arrowCenterX, y: arrowCenterY)
        
        if arrowView.constraints.count == 0 {
            arrowView.xm_size = arrowView.image?.size ?? CGSize.zero
            arrowView.center = arrowCenter
        }
        if loadingView.constraints.count == 0 {
            loadingView.center = arrowCenter
        }
        arrowView.tintColor = stateLabel.textColor
    }
    public override func set(newState: XMRefreshState) {
        let oldState = state
        if oldState == newState {
            return
        }
        super.set(newState: newState)
        if newState == .idle {
            if oldState == .refreshing {
                arrowView.transform = CGAffineTransform.identity
                UIView.animate(withDuration: XMRefreshSlowAnimationDuration, animations: {
                    self.loadingView.alpha = 0.0
                }, completion: { (finished) in
                    if self.state != .idle {
                        return
                    }
                    self.loadingView.alpha = 1.0
                    self.loadingView.stopAnimating()
                    self.arrowView.isHidden = false
                })
            } else {
                loadingView.stopAnimating()
                arrowView.isHidden = false
                UIView.animate(withDuration: XMRefreshFastAnimationDuration, animations: {
                    self.arrowView.transform = CGAffineTransform.identity
                })
            }
        } else if newState == .pulling {
            loadingView.stopAnimating()
            arrowView.isHidden = false
            UIView.animate(withDuration: XMRefreshFastAnimationDuration, animations: {
                self.arrowView.transform = CGAffineTransform.init(rotationAngle: CGFloat(0.000001 - Double.pi))
            })
        } else if newState == .refreshing {
            loadingView.alpha = 1.0
            loadingView.startAnimating()
            arrowView.isHidden = true
        }
    }
    
}

