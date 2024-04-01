//
//  LanguageModel.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import UIKit

// MARK: - 언어 모델

enum LanguageModel {
    case english
    case korean
    case morse

    var type: String {
        switch self {
        case .english:
            return "영어"
        case .korean:
            return "한글"
        case .morse:
            return "모스부호"
        }
    }
}

final class ModeManager {
    static let shared = ModeManager()

    private let defaults = UserDefaults.standard
    var mode = true

    func changeLightMode() {
        defaults.set(DarkMode.light.type, forKey: "mode")
        mode = defaults.bool(forKey: "mode")
    }

    func changeDarkMode() {
        defaults.set(DarkMode.dark.type, forKey: "mode")
        mode = defaults.bool(forKey: "mode")
    }

    private init() {}
}

// MARK: - 다크 모드

enum DarkMode {
    case light
    case dark

    var type: Bool {
        switch self {
        case .light:
            return true
        case .dark:
            return false
        }
    }
}

// MARK: - UI 타입

enum UIType {
    case selectButton
    case unSelectButton
    case view
    case background
    case text
    case placeHolder

    var uiColor: UIColor {
        switch self {
        case .selectButton:
            return ModeManager.shared.mode ? .systemPink : .systemOrange
        case .unSelectButton:
            return ModeManager.shared.mode ? .systemTeal : .systemIndigo
        case .view:
            return ModeManager.shared.mode ? .systemGray5 : .systemGray.withAlphaComponent(0.5)
        case .background:
            return ModeManager.shared.mode ? .white : .black
        case .text:
            return ModeManager.shared.mode ? .black : .white
        case .placeHolder:
            return ModeManager.shared.mode ? .systemGray : .systemGray6.withAlphaComponent(0.6)
        }
    }
}
