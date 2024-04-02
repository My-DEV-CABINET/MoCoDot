//
//  MorseListCoordinator.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import UIKit

final class MorseListCoordinator: Coordinator {
    let container = DIContainer.shared
    var childCoordinators: [Coordinator] = []

    private var navigationController: UINavigationController!

    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }

    func start() {
        // 모스코드 소리 재생 서비스
        let soundService = self.container.resolve(type: SoundServiceProtocol.self)!

        let vc = MorseListVC()
        vc.viewmodel = MorseListViewModel(soundService: soundService)

        let modalVC = UINavigationController(rootViewController: vc)
        modalVC.modalPresentationStyle = .pageSheet

        // 모달로 MorseListVC 표시
        self.navigationController.present(modalVC, animated: true, completion: nil)
    }
}
