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

    var currentMode: Bool {
        get { return defaults.bool(forKey: UserDefaultsKey.mode.str) }
        set { defaults.set(newValue, forKey: UserDefaultsKey.mode.str) }
    }

    func changeMode(_ bool: Bool) {
        currentMode = bool
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
