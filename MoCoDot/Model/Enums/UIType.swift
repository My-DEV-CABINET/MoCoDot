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

    var type: String {
        switch self {
        case .selectButton:
            return "SelectButton"
        case .unSelectButton:
            return "UnSelectButton"
        case .view:
            return "View"
        case .background:
            return "Background"
        case .text:
            return "Text"
        case .placeHolder:
            return "Placeholder"
        }
    }
}
