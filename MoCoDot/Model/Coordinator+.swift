//
//  Coordinator+.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

protocol MorseTranslateVCDelegate {
    func showMorseList()
}

protocol MorseTranslateCoordinatorDelegate {
    func didTappedShowMorseList(_ coordinator: MorseTranslateCoordinator)
}
