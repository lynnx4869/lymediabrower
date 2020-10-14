//
//  DocumentController.swift
//  lymediabrower
//
//  Created by xianing on 2018/9/17.
//  Copyright © 2018年 czcg. All rights reserved.
//

import UIKit
import WebKit

class DocumentController: UIViewController, WKNavigationDelegate, WKUIDelegate, UIScrollViewDelegate {
    
    var file: FileModel!
    
    fileprivate var wbWebView: WKWebView!
    
    fileprivate let progressView = UIProgressView(progressViewStyle: .default)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.title = file.itemName
        
        let wkConfig = WKWebViewConfiguration()
        wbWebView = WKWebView(frame: .zero, configuration: wkConfig)
        wbWebView.navigationDelegate = self
        wbWebView.uiDelegate = self
        view.addSubview(wbWebView)
        
        wbWebView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        progressView.isHidden = true
        view.addSubview(progressView)
        
        progressView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(0)
            make.left.equalTo(self.view.snp.left).offset(0)
            make.right.equalTo(self.view.snp.right).offset(0)
            make.height.equalTo(3)
        }
        
        wbWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        let urlString = (Consts.rootUrl() + file.playPath).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let request = URLRequest(url: URL(string: urlString)!)
        wbWebView.load(request)
        URLCache.shared.removeCachedResponse(for: request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        wbWebView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UserDefaults.standard.set(0, forKey: "WebKitCacheModelPreferenceKey")
        
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        debugPrint(message)
        completionHandler()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            let estimatedProgress = wbWebView.estimatedProgress
            progressView.setProgress(Float(estimatedProgress), animated: true)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}
