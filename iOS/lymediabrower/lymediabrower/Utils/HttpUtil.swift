//
//  HttpUtil.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import Foundation
import Alamofire
import LYAutoUtils

struct HttpUtil {
    
    static func request(url: String,
                        parameters: [String: Any]?,
                        success: @escaping (Any)->Void,
                        failure: @escaping (Error)->Void) {
        
        var headers = [String: String]()
        headers["Content-Type"] = "application/json; charset=UTF-8"

        let urlString = (Consts.rootUrl() + url).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(urlString,
                          method: .post,
                          parameters: parameters,
                          encoding: JSONEncoding.default,
                          headers: headers)
            .responseJSON { response in
                if response.error != nil {
                    LYAutoPop.show(message: "网络错误", type: .error, duration: 2.0)
                    failure(response.error!)
                } else {
                    success(response.result.value!)
                }
        }
    }
    
}
