//
//  MorseCoordinator.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

import UIKit

final class MorseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        //
    }

    func confirmVC() -> UIViewController {
        let morseVC = MorseTranslateView()
        return morseVC
    }
}
