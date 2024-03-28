//
//  KoreanToMorseTranslateProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import Foundation

/// 한글 -> 모스코드 변환 프로토콜
protocol KoreanToMorseTranslateProtocol {
    var inputText: String { get }
    var transResult: String { get set }
    var morseList: [[MorseProtocol]] { get }

    func translateKoreanToUtf(at message: String) -> [Int]
    func translateMorse(at inputTexts: String) -> String
    func reset()
}
