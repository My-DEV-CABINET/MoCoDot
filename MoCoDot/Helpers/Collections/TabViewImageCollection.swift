//
//  TabViewImageCollection.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

import Foundation

enum TabViewImageCollection {
    case language
    case morse
    case quiz
    case history
    case bookmark

    var symbolName: String {
        switch self {
        case .language:
            return "text.bubble"
        case .morse:
            return "list.bullet"
        case .quiz:
            return "questionmark"
        case .history:
            return "clock"
        case .bookmark:
            return "bookmark"
        }
    }
}
