//
//  Bundle_Refresh.swift
//  XMRefresh
//
//  Created by ming on 2017/11/13.
//  Copyright © 2017年 TiandaoJiran. All rights reserved.
//

import Foundation
import UIKit
extension Bundle {
    private static var localizedBundle: Bundle?
    private static var _refreshBundle: Bundle?
    private static var refreshBundle: Bundle {
        if _refreshBundle == nil {
            let frameworkBundle = Bundle.init(for: XMRefreshComponent.classForCoder())
            _refreshBundle = Bundle.init(path: frameworkBundle.path(forResource: "XMRefresh", ofType: "bundle") ?? "")
//            let bundle = Bundle.init(path: ResourcesBundle?.path(forResource: "XImagePickerController", ofType: "bundle") ?? "")
        }
        return _refreshBundle ?? main
    }

    private static let arrowImage: UIImage? = UIImage.init(contentsOfFile: refreshBundle.path(forResource: "arrow@2x", ofType: "png") ?? "")?.withRenderingMode(.alwaysTemplate)

    class func xm_arrowImage() -> UIImage? {
        return arrowImage
    }
    class func xm_localizedString(key: String, value: String)  -> String {
        if localizedBundle == nil {
            var language = Locale.preferredLanguages.first
            if language?.range(of: "zh-Hans") != nil {
                language = "zh-Hans"
            } else if language?.range(of: "zh-Hant") != nil{
                language = "zh-Hant"
            } else {
                language = "en"
            }
            localizedBundle = Bundle.init(path: refreshBundle.path(forResource: language, ofType: "lproj") ?? "")
        }
        let valueStr = localizedBundle?.localizedString(forKey: key, value: value, table: nil)
        return main.localizedString(forKey: key, value: valueStr, table: nil)
    }
}
