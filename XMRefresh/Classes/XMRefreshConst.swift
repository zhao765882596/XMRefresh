//
//  XMRefreshConst.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import Foundation
import UIKit

let XMRefreshLabelTextColor = UIColor.init(red: 90 / 255.0, green: 90 / 255.0, blue: 90 / 255.0, alpha: 1.0)

let XMRefreshLabelFont = UIFont.boldSystemFont(ofSize: 14)

let XMRefreshLabelLeftInset: CGFloat = 25
let XMRefreshHeaderHeight: CGFloat = 54
let XMRefreshFooterHeight: CGFloat = 44
let XMRefreshFastAnimationDuration: TimeInterval = 0.25
let XMRefreshSlowAnimationDuration: CGFloat = 0.4

let XMRefreshKeyPathContentOffset = "contentOffset"
let XMRefreshKeyPathContentInset = "contentInset"
let XMRefreshKeyPathContentSize = "contentSize"
let XMRefreshKeyPathPanState = "state"

let XMRefreshHeaderLastUpdatedTimeKey = "RefreshHeaderLastUpdatedTimeKey"
let XMRefreshHeaderIdleText = "RefreshHeaderIdleText"
let XMRefreshHeaderPullingText = "RefreshHeaderPullingText"
let XMRefreshHeaderRefreshingText = "RefreshHeaderRefreshingText"

let XMRefreshAutoFooterIdleText = "RefreshAutoFooterIdleText"
let XMRefreshAutoFooterRefreshingText = "RefreshAutoFooterRefreshingText"
let XMRefreshAutoFooterNoMoreDataText = "RefreshAutoFooterNoMoreDataText"

let XMRefreshBackFooterIdleText = "RefreshBackFooterIdleText"
let XMRefreshBackFooterPullingText = "RefreshBackFooterPullingText"
let XMRefreshBackFooterRefreshingText = "RefreshBackFooterRefreshingText"
let XMRefreshBackFooterNoMoreDataText = "RefreshBackFooterNoMoreDataText"

let XMRefreshHeaderLastTimeText = "RefreshHeaderLastTimeText"
let XMRefreshHeaderDateTodayText = "RefreshHeaderDateTodayText"
let XMRefreshHeaderNoneLastDateText = "RefreshHeaderNoneLastDateText"
