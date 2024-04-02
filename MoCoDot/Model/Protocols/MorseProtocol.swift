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
