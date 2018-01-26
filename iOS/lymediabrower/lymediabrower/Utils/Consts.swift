//
//  Consts.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import LYAutoUtils

struct Consts {
    
    /// 主题色
    static let MainColor = UIColor.color(hex: 0x887ddd)
    
    /// 网络根路径
    static func rootUrl() -> String {
        return AppConfig.shared.RootUrl
    }
    
    static func iPhoneX() -> Bool {
        let width = LyConsts.ScreenWidth
        let height = LyConsts.ScreenHeight
        let maxHeight = max(width!, height!)
        return maxHeight == 812 ? true : false
    }
    
    fileprivate static let images = [
        UIImage(named: "icon001"),
        UIImage(named: "icon002"),
        UIImage(named: "icon003"),
        UIImage(named: "icon004"),
        UIImage(named: "icon005"),
        UIImage(named: "icon006"),
        UIImage(named: "icon007"),
        UIImage(named: "icon008"),
    ]
    
    static func getDefaultImage() -> UIImage {
        let i = Int(arc4random()) % Consts.images.count
        return Consts.images[i]!
    }
    
}
