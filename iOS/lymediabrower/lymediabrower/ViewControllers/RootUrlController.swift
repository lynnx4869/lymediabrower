//
//  RootUrlController.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit
import LYAutoUtils

class RootUrlController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sureUrl(_ sender: UIButton) {
        let url = textField.text
        
        if url == nil || url == "" {
            LYAutoPop.show(message: "根路径不能为空",
                           type: .error,
                           duration: 2.0)
        } else {
            let config = AppConfig.shared
            config.RootUrl = "http://" + url!
            config.saveAppConfig()
            
            NotificationCenter.default.post(name: Notification.Name("CHANGEROOT"), object: nil)
        }
    }
    
}
