//
//  EnglishTranslateService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/28/24.
//

import Foundation

/// 영어 -> 모스코드 변환 프로토콜
final class EnglishToMorseTranslateService: EnglishToMorseTranslateProtocol {
    var inputText: String = ""
    var transResult: String = ""
    var morseList: [MorseProtocol] = EnglishMorse.morseList

    /// 전체 문자열 받아들이는 메서드
    /// - Parameter inputText: View에서 입력된 전체 영어 문자열
    /// - Returns: 변환된 모스코드 문자열
    func requestInputTextArr(at inputText: String) -> String {
        let temp = inputText.split(separator: "")
        var result = ""

        for temp_index in 0 ..< temp.count {
            result = translateMorse(at: String(temp[temp_index]).uppercased())
        }

        return result
    }

    /// 들어오는 문자 1개를 모스코드 1개로 변환하는 메서드
    /// - Parameter inputTexts: 영어 알파벳 1개
    /// - Returns: 변환된 모스코드 1개
    func translateMorse(at inputTexts: String) -> String {
        for morseIndex in 0 ..< morseList.count {
            if inputTexts == morseList[morseIndex].alphabetName {
                transResult += morseList[morseIndex].morseCode + " "

                if inputTexts == "\n" {
                    transResult += "\n"
                }
            }
        }

        return transResult
    }

    /// 기존에 변환된 문자열 초기화 메서드
    func reset() {
        transResult = ""
    }
}
