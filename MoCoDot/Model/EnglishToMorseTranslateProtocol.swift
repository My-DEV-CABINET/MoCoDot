//
//  TranslateProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Foundation

/// 영어 -> 모스코드 변환 프로토콜
protocol EnglishToMorseTranslateProtocol {
    var inputText: String { get }
    var transResult: String { get set }
    var morseList: [MorseProtocol] { get }

    func requestInputTextArr(at inputText: String) -> String
    func translateMorse(at inputTexts: String) -> String
    func reset()
}
