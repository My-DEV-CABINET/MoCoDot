//
//  UIType.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/1/24.
//

import UIKit

// MARK: - UI 타입

enum UIType {
    case selectButton
    case unSelectButton
    case view
    case background
    case text
    case placeHolder

    func uiColor(forMode isDarkMode: Bool) -> UIColor {
        switch self {
        case .selectButton:
            return isDarkMode ? .systemPink : .systemOrange
        case .unSelectButton:
            return isDarkMode ? .systemTeal : .systemIndigo
        case .view:
            return isDarkMode ? .systemGray5 : .systemGray.withAlphaComponent(0.5)
        case .background:
            return isDarkMode ? .white : .black
        case .text:
            return isDarkMode ? .black : .white
        case .placeHolder:
            return isDarkMode ? .systemGray : .systemGray6.withAlphaComponent(0.6)
        }
    }
}
