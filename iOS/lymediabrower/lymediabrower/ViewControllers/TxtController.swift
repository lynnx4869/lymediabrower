//
//  TxtController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/17.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import WebKit

class TxtController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    var file: FileModel!
    
    fileprivate var wbWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = file.itemName
        
        let wkConfig = WKWebViewConfiguration()
        wbWebView = WKWebView(frame: .zero, configuration: wkConfig)
        wbWebView.navigationDelegate = self
        wbWebView.uiDelegate = self
        view.addSubview(wbWebView!)
        
        wbWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        let urlString = (Consts.rootUrl() + file.playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = URLRequest(url: URL(string: urlString)!)
        wbWebView.load(request)
        URLCache.shared.removeCachedResponse(for: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UserDefaults.standard.set(0, forKey: "WebKitCacheModelPreferenceKey")
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        debugPrint(message)
        completionHandler()
    }

}
