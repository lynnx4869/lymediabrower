//
//  AppDelegate.swift
//  lymediabrower
//
//  Created by xianing on 2017/11/15.
//  Copyright © 2017年 czcg. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        
        /**
         *  设置全局风格
         */
        UINavigationBar.appearance().barTintColor = Consts.MainColor
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barStyle = .black
        UIApplication.shared.statusBarStyle = .lightContent
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        
        //初始化界面
        setRootVcForDefault()
        registerNotifications()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - System
    
    /// 获取默认控制器
    ///
    /// - Returns: 默认控制器
    fileprivate func getRootController() -> UIViewController {
        let config = AppConfig.shared
        
        if config.RootUrl == "" {
            let ruc = RootUrlController()
            return ruc
        } else {
            let mc = ModulesController()
            let nav = UINavigationController(rootViewController: mc)
            nav.navigationBar.isTranslucent = false
            return nav
        }
    }

    /// 设置默认根控制器
    fileprivate func setRootVcForDefault() {
        window?.rootViewController = getRootController()
    }
    
    /// 注册全局监听
    fileprivate func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeRootController(noti:)),
                                               name: Notification.Name("CHANGEROOT"),
                                               object: nil)
    }
    
    /// 切换根路径
    ///
    /// - Parameter noti: 通知
    @objc fileprivate func changeRootController(noti: Notification) {
        window?.rootViewController = nil
        window?.rootViewController = getRootController()
    }

}

