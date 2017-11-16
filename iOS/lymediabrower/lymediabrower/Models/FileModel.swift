//
//  FileModel.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import Foundation

class FileModel: NSObject {
    
    @objc var itemName: String!
    @objc var itemPath: String!
    @objc var playPath: String!
    @objc var type: String!
    
    var imageIndex: Int!
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        debugPrint(key)
    }
    
}
