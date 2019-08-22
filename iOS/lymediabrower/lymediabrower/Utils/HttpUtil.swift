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
import SwiftyJSON
import RxSwift
import RxCocoa

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
                if let error = response.error {
                    LYAutoPop.show(message: "网络错误", type: .error, duration: 2.0)
                    failure(error)
                } else {
                    success(response.result.value!)
                }
        }
    }
    
}

enum Api {
    
    static func modules() -> Observable<[FileModel]> {
        return Observable.create { observer -> Disposable in
            HttpUtil.request(url: "/modules",
                             parameters: nil,
                             success:
            { data in
                let json = JSON(data)
                
                var items = [FileModel]()
                if let modules = json["modules"].array {
                    for item in modules {
                        if let itemDic = item.dictionaryObject {
                            let oneFile = FileModel()
                            oneFile.setValuesForKeys(itemDic)
                            items.append(oneFile)
                        }
                    }
                }
                
                observer.onNext(items)
                observer.onCompleted()
            })
            { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
    static func files(_ fileroot: String, _ modulePath: String) -> Observable<[FileModel]> {
        return Observable.create { observer -> Disposable in
            HttpUtil.request(url: "/files",
                             parameters: ["fileroot": fileroot, "modulePath": modulePath],
                             success:
                { (data) in
                    let json = JSON(data)
                    
                    var items = [FileModel]()
                    if let fileList = json["fileList"].array {
                        for item in fileList {
                            if let file = item.dictionaryObject {
                                let oneFile = FileModel()
                                oneFile.setValuesForKeys(file)
                                items.append(oneFile)
                            }
                        }
                    }
                    
                    observer.onNext(items)
                    observer.onCompleted()
            }) { error in
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
    
}


