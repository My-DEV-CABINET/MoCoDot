//
//  AppCoordinator.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import UIKit

// MARK: - AppCoordinator

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    let window: UIWindow

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
        window.rootViewController = navigationController
    }

    func start() {
        showSplashViewAndTabView()
    }

    private func showSplashViewAndTabView() {
        let tabCoordinator = TabCoordinator(navigationController: navigationController)
        childCoordinators.append(tabCoordinator)
        tabCoordinator.start()
        window.makeKeyAndVisible()
    }
}
