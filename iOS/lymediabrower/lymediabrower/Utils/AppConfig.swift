//
//  AppConfig.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import Foundation

class AppConfig {
    
    /// 根路径
    var RootUrl: String!
    
    static let shared = AppConfig()
    fileprivate init() {
        loadConfig()
    }
    
    fileprivate func loadConfig() {
        let config = UserDefaults.standard
        
        if config.string(forKey: "RootUrl") != nil {
            RootUrl = config.string(forKey: "RootUrl")
        } else {
            RootUrl = ""
        }
    }
    
    func saveAppConfig() {
        let config = UserDefaults.standard
        
        if RootUrl != nil {
            config.set(RootUrl, forKey: "RootUrl")
        }
    }
    
}
