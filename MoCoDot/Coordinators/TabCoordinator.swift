//
//  TabCoordinator.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

import UIKit

final class TabCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var tabBarController: MainTabView!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        showTabView()
    }

    private func showTabView() {
        tabBarController = MainTabView()

        // 각 탭을 관리하는 코디네이터를 설정
        let languageCoordinator = LanguageCoordinator(navigationController: navigationController)
        childCoordinators.append(languageCoordinator)
        let languageVC = generateViewControllers(image: UIImage(systemName: TabViewImageCollection.language.symbolName)!,
                                                 selectedImageName: TabViewImageCollection.language.symbolName,
                                                 vc: languageCoordinator.confirmVC())

        let morseCoordinator = MorseCoordinator(navigationController: navigationController)
        childCoordinators.append(morseCoordinator)
        let morseVC = generateViewControllers(image: UIImage(systemName: TabViewImageCollection.morse.symbolName)!,
                                              selectedImageName: TabViewImageCollection.morse.symbolName,
                                              vc: morseCoordinator.confirmVC())

        let historyCoordinator = HistoryCoordinator(navigationController: navigationController)
        childCoordinators.append(historyCoordinator)
        let historyVC = generateViewControllers(image: UIImage(systemName: TabViewImageCollection.history.symbolName)!,
                                                selectedImageName: TabViewImageCollection.history.symbolName,
                                                vc: historyCoordinator.confirmVC())

        let bookmarkCoordinator = BookmarkCoordinator(navigationController: navigationController)
        childCoordinators.append(bookmarkCoordinator)
        let bookmarkVC = generateViewControllers(image: UIImage(systemName: TabViewImageCollection.bookmark.symbolName)!,
                                                 selectedImageName: TabViewImageCollection.bookmark.symbolName,
                                                 vc: bookmarkCoordinator.confirmVC())

        // MainTabView에 각 뷰 컨트롤러를 설정
        tabBarController.viewControllers = [languageVC, morseVC, historyVC, bookmarkVC]
        navigationController.viewControllers = [tabBarController]
    }

    private func generateViewControllers(image: UIImage, selectedImageName: String, vc: UIViewController) -> UIViewController {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        let resizedImage = image.resize(targetSize: CGSize(width: 25, height: 25)).withRenderingMode(.alwaysTemplate)
        button.setImage(resizedImage, for: .normal)
        button.setImage(UIImage(systemName: selectedImageName)?.withRenderingMode(.alwaysTemplate), for: .selected)
        tabBarController.buttons.append(button)
        return vc
    }
}
