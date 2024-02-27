//
//  TranslateProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Foundation

protocol TranslateProtocol {
    var transResult: String { get set }
    var morseList: [MorseProtocol] { get }

    func translateMorse(at inputTexts: [String]) -> String
    func reset()
}
