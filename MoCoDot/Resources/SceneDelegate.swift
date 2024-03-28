//
//  SceneDelegate.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let container = DIContainer.shared

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        self.window = UIWindow(windowScene: windowScene)

        let rootViewController = MorseTranslateVC()
        // 영어 <-> 모스코드 번역 서비스
        let englishTranslateService = self.container.resolve(type: EnglishToMorseTranslateProtocol.self)!
        // 한글 <-> 모스코드 번역 서비스
        let koreanTranslateService = self.container.resolve(type: KoreanToMorseTranslateProtocol.self)!
        // 모스코드 소리 재생 서비스
        let soundService = self.container.resolve(type: SoundServiceProtocol.self)!
        // 핸드폰 불빛 On/Off 서비스
        let flashService = self.container.resolve(type: FlashServiceProtocol.self)!
        // 핸드폰 진동 On/Off 서비스
        let tapticService = self.container.resolve(type: TapticServiceProtocol.self)!

        // 의존성 주입
        rootViewController.viewModel = MorseTranslateViewModel(englishTranslateService: englishTranslateService, koreanTranslateService: koreanTranslateService, soundService: soundService, flashService: flashService, tapticService: tapticService)

        let rootNavigationController = UINavigationController(rootViewController: rootViewController)

        self.window?.rootViewController = rootNavigationController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
