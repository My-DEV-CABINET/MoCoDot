//
//  UserDefaultsKey.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import Foundation

// MARK: - 다크 모드

enum UserDefaultsKey {
    case mode

    var str: String {
        switch self {
        case .mode:
            return "mode"
        }
    }
}
