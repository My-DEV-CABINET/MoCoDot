//
//  KoreanToMorseTranslateService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import Foundation

final class KoreanToMorseTranslateService: KoreanToMorseTranslateProtocol {
    var inputText: String = ""
    var transResult: String = ""
    var morseList: [[MorseProtocol]] = KoreanMorse.koreanMorseList

    /// 한글 -> UTF16 으로 변환하는 메서드
    /// - Parameter message: 한글(ex: 안)
    /// - Returns: UTF16 기반 Int 배열
    func translateKoreanToUtf(at message: String) -> [Int] {
        var answer = [Int]()
        var count = 0
        for i in message.utf16 {
            count = Int(i)
            let x = ((count - 0xAC00) / 28) / 21 // 초성
            answer.append(x)

            let y = ((count - 0xAC00) / 28) % 21 // 중성
            answer.append(y)

            let z = (count - 0xAC00) % 28 - 1 // 종성
            answer.append(z)
        }

        return answer
    }

    /// 입력받은 한글 문자열 -> UTF16 으로 변환 -> Morse 변환 하는 메서드
    /// - Parameter inputTexts: 한글 문자열(ex: 안녕하세요)
    /// - Returns: 모스코드 문자
    func translateMorse(at inputTexts: String) -> String {
        let koreanText = inputTexts.split(separator: "").joined()
        var answer = ""

        for i in koreanText {
            let utfList = translateKoreanToUtf(at: String(i))
            let x = utfList[0] >= 0
            answer += x ? morseList[0][utfList[0]].morseCode + " " : ""

            let y = utfList[1] >= 0
            answer += y ? morseList[1][utfList[1]].morseCode + " " : ""

            let z = utfList[2] >= 0
            answer += z ? morseList[2][utfList[2]].morseCode + " " : ""

            if i == " " {
                answer += " "
            } else if i == "\n" {
                answer += "\n"
            } else {
                answer += " "
            }
        }

        return answer
    }

    func reset() {
        transResult = ""
    }
}
