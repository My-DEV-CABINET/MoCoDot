//
//  ModeManager.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import Foundation

final class ModeManager {
    static let shared = ModeManager()

    private let defaults = UserDefaults.standard
    private var mode = true
    var currentMode = UserDefaults.standard.bool(forKey: UserDefaultsKey.mode.str)

    func changeMode(_ bool: Bool) {
        defaults.set(bool, forKey: UserDefaultsKey.mode.str)
    }

    private init() {}
}

enum UserDefaultsKey {
    case mode

    var str: String {
        switch self {
        case .mode:
            return "mode"
        }
    }
}
