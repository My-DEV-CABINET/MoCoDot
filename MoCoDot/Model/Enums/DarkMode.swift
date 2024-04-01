//
//  DarkMode.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import Foundation

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
