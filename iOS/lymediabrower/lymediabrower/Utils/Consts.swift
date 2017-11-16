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

}
