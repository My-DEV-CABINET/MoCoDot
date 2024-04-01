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
    func translateMorse(at input: String) -> String {
        let koreanText = input.split(separator: "").joined()
        var answer = ""

        for i in koreanText.enumerated() {
            let utfList = translateKoreanToUtf(at: i.element.description)
            let x = utfList[0] >= 0
            let y = utfList[1] >= 0
            let z = utfList[2] >= 0

            answer += x ? morseList[0][utfList[0]].morseCode : ""
            answer += y ? morseList[1][utfList[1]].morseCode : ""
            answer += z ? morseList[2][utfList[2]].morseCode : ""

            if x == false, y == false, z == false {
                for d in zip(morseList[0], morseList[1]) {
                    if d.0.alphabetName == i.element.description {
                        answer += d.0.morseCode
                    }
                    else if d.1.alphabetName == i.element.description {
                        answer += d.1.morseCode
                    }
                }
            }

            if i.offset < koreanText.count - 1 {
                answer += " "
            }
            else if i.element == "\n" {
                answer += "\n"
            }
            else {
                answer += ""
            }
        }

        return answer
    }

    func reset() {
        transResult = ""
    }
}
