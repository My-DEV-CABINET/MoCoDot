//
//  Morse.swift
//  MorseCode
//
//  Created by (^ㅗ^)7 iMac on 2023/07/01.
//

import Foundation

protocol MorseProtocol {
    /// 영어 : 알파벳
    /// 한글 : 자음/모음
    var alphabetName: String { get }
    var morseCode: String { get }
}

// MARK: - 언어 모델

enum LanguageModel {
    case english
    case korean

    var type: String {
        switch self {
        case .english:
            return "English"
        case .korean:
            return "한글"
        }
    }
}
