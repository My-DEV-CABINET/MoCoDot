//
//  AppDelegate.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let container = DIContainer.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // 세로 모드 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
