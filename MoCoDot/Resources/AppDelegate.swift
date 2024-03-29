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
        // DIContainer 의존성 등록
        container.register(type: EnglishToMorseTranslateProtocol.self, service: EnglishToMorseTranslateService())
        container.register(type: KoreanToMorseTranslateProtocol.self, service: KoreanToMorseTranslateService())
        container.register(type: SoundServiceProtocol.self, service: SoundService())
        container.register(type: FlashServiceProtocol.self, service: FlashService())

        #if DEVELOPMENT
        container.register(type: TapticServiceProtocol.self, service: TapticService())
        print("# I am Development")
        #else
        container.register(type: TapticServiceProtocol.self, service: MockupTapticService())

        print("# I am DEBUG")
        #endif

        return true
    }

    // 세로 모드 고정
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
}
