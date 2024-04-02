//
//  TranslateKoreanToMorseTests.swift
//  MoCoDotTests
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import XCTest

@testable import MoCoDot

final class TranslateKoreanToMorseTests: XCTestCase {
    private var koreanTranslateService: KoreanToMorseTranslateProtocol!
    private var morseList = KoreanMorse.koreanMorseList

    // 각각의 테스트 메서드가 실행되기 전에 setup 이 먼저 실행되어 값을 재설정 시켜줌
    override func setUp() {
        super.setUp()

        /// 초기화
        koreanTranslateService = KoreanToMorseTranslateService()
    }

    func translateKoreanToUtf(at message: String) -> [Int] {
        var answer = [Int]()
        var index = 0
        for i in message.utf16 {
            index = Int(i)

            let cho = ((index - 0xAC00) / 28) / 21 // 초성
            answer.append(cho)

            let jung = ((index - 0xAC00) / 28) % 21 // 중성
            answer.append(jung)

            let jong = (index - 0xAC00) % 28 - 1 // 종성
            answer.append(jong)
        }

        return answer
    }

    func checkKoreanSingleCharacter(input: String) -> String {
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

    func test() {
        var result = checkKoreanSingleCharacter(input: "ㄱ")
        print("#### &&& \(result)")

//        XCTAssertEqual(checkKoreanSingleCharacter(input: "ㄱㅏ"), ".-..")
    }

    override class func tearDown() {
        super.tearDown()
    }
}
