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
