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
    private var naviagtionController: UINavigationController!

    init(naviagtionController: UINavigationController) {
        self.naviagtionController = naviagtionController
    }

    func start() {
        self.showMorseTranslateVC()
    }

    // 모스부호 번역 페이지로 가기
    private func showMorseTranslateVC() {
        let coordinator = MorseTranslateCoordinator(navigationController: self.naviagtionController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }

    // 모스부호 리스트로 가기
    private func showMorseListVC() {
        let coordinator = MorseListCoordinator(navigationController: self.naviagtionController)
        coordinator.start()
        self.childCoordinators.append(coordinator)
    }
}

extension AppCoordinator: MorseTranslateCoordinatorDelegate {
    func didTappedShowMorseList(_ coordinator: MorseTranslateCoordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
        self.showMorseListVC()
    }
}
