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

    var identifier: String {
        switch self {
        case .english:
            return "en-US"
        case .korean:
            return "ko-KR"
        case .morse:
            return "N"
        }
    }
}
