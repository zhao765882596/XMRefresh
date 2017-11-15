//
//  RefreshComponent.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

public enum XMRefreshState: Int {

    /// ** 普通闲置状态 *
    case idle = 1
    /// 松开就可以进行刷新的状态
    case pulling = 2
    /// 正在刷新中的状态
    case refreshing = 3
    /// 即将刷新的状态
    case willRefresh = 4
    /// 所有数据加载完毕，没有更多的数据了
    case noMoreData = 5
}
public class XMRefreshComponent: UIView {
    /// 记录scrollView刚开始的inset
    var scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets()
    /// 父控件
    weak var scrollView: UIScrollView?


    /// 正在刷新的回调
    public var refreshing: (() -> Void)?
    /// 回调对象
    public var refreshingTarget: AnyObject?
    /// 回调方法 */
    public var refreshingAction: Selector?

    /// 开始刷新后的回调(进入刷新状态后的回调)
    public var beginRefreshingCompletion: (() -> Void)?
    /// 结束刷新的回调 */
    public var endRefreshingCompletion: (() -> Void)?

    /// 是否正在刷新 */
    public var isRefreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }
    /// 刷新状态 
    public var state:XMRefreshState = .idle {
        didSet {
            DispatchQueue.main.async {
                self.setNeedsLayout()
                self.set(oldState: oldValue)
            }
        }
    }

    ///  刷新状态 一般交给子类内部实现
    public func set(oldState: XMRefreshState) {

    }

    /// 拉拽的百分比(交给子类重写)
    public var pullingPercent: CGFloat = 0.0 {
        didSet {
            if state == .refreshing {
                return
            }
            if isAutomaticallyChangeAlpha {
                alpha = pullingPercent
            }
        }
    }
    /// 根据拖拽比例自动切换透明度
    public var isAutomaticallyChangeAlpha = false {
        didSet {
            if state == .refreshing {
                return
            }
            if isAutomaticallyChangeAlpha {
                alpha = pullingPercent
            } else {
                alpha = 1.0
            }
        }
    }

    private var pan: UIPanGestureRecognizer?

    init(refreshing: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        self.refreshing = refreshing
    }
    init(target: AnyObject?, action: Selector?) {
        super.init(frame: CGRect.zero)
        setRefreshing(target: target, action: action)

    }
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        prepare()
//    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func layoutSubviews() {
        placeSubviews()
        super.layoutSubviews()
    }
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let scroll = newSuperview as? UIScrollView else { return }

        xm_width = scroll.xm_width
        xm_x = 0.0 - (scrollView?.xm_insetL ?? 0)
        scrollView = scroll
        scrollView?.alwaysBounceVertical = true
        scrollViewOriginalInset = scrollView?.xm_inset ?? UIEdgeInsets()
        addObservers();
    }
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .willRefresh {
            state = .refreshing
        }
    }
    func addObservers() {
        let options: NSKeyValueObservingOptions = [.new, .old]
        guard let scr = scrollView else { return }
        scr.addObserver(self, forKeyPath: XMRefreshKeyPathContentOffset, options: options, context: nil)
        scr.addObserver(self, forKeyPath: XMRefreshKeyPathContentSize, options: options, context: nil)
        pan = scr.panGestureRecognizer
        pan?.addObserver(self, forKeyPath: XMRefreshKeyPathPanState, options: options, context: nil)
    }
    func removeObservers() {
        superview?.removeObserver(self, forKeyPath: XMRefreshKeyPathContentOffset)
        superview?.removeObserver(self, forKeyPath: XMRefreshKeyPathContentSize)
        pan?.removeObserver(self, forKeyPath: XMRefreshKeyPathPanState)
        pan = nil
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !isUserInteractionEnabled {
            return
        }
        if keyPath == XMRefreshKeyPathContentSize {
            scrollViewContentSizeDidChange(Change: change)
        }

        if isHidden {
            return
        }
        if keyPath == XMRefreshKeyPathContentOffset {
            scrollViewContentOffsetDidChange(Change: change)
        } else if keyPath == XMRefreshKeyPathPanState {
            scrollViewPanStateDidChange(Change: change)
        }
    }


    /// 设置回调对象和回调方法
    public func setRefreshing(target: AnyObject?, action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }

    /// 进入刷新状态
    public func beginRefreshing(completion: (() -> Void)? = nil) {
        beginRefreshingCompletion = completion
        UIView.animate(withDuration: XMRefreshFastAnimationDuration) {
            self.alpha = 1.0
        }
        pullingPercent = 1.0
        if window != nil {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .willRefresh
                setNeedsDisplay()
            }
        }
    }

    /// 结束刷新状态
   public  func endRefreshing(completion: (() -> Void)? = nil) {
        endRefreshingCompletion = completion
        DispatchQueue.main.async {
            self.state = .idle
        }
    }


    // MARK: - 子类实现
    /// ** 初始化 */
    public func prepare() {
        autoresizingMask = [.flexibleWidth]
        backgroundColor = UIColor.clear
    }
    /// 摆放子控件frame
    public func placeSubviews() {

    }
    /// 当scrollView的contentOffset发生改变的时候调用
    public func scrollViewContentOffsetDidChange(Change: Dictionary<AnyHashable, Any>?) {

    }
    /// 当scrollView的contentSize发生改变的时候调用
    public func scrollViewContentSizeDidChange(Change: Dictionary<AnyHashable, Any>?) {

    }
    /// 当scrollView的拖拽状态发生改变的时候调用
    public func scrollViewPanStateDidChange(Change: Dictionary<AnyHashable, Any>?) {

    }
    /// 触发回调（交给子类去调用
    func executeRefreshingCallback() {
        DispatchQueue.main.async {
            if self.refreshing != nil {
                self.refreshing!()
            }
            if self.refreshingTarget?.responds(to: self.refreshingAction) == true {
                self.refreshingTarget?.perform(self.refreshingAction!, with: nil, afterDelay: 0)
            }
            if self.beginRefreshingCompletion != nil {
                self.beginRefreshingCompletion!()
            }
        }
    }
}

extension UILabel {
    static var xm_label: UILabel {
        let label = UILabel()
        label.font = XMRefreshLabelFont
        label.textColor = XMRefreshLabelTextColor
        label.autoresizingMask = [.flexibleWidth]
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    func xm_textWith() -> CGFloat {
        return (text ?? "").boundingRect(with: CGSize.init(width: Int.max, height: Int.max), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font, NSAttributedStringKey.strokeColor: XMRefreshLabelTextColor], context: nil).width
    }

}









