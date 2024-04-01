//
//  UIType.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import Foundation

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
