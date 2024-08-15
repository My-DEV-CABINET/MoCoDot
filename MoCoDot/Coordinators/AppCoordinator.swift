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
        //
    }
}
