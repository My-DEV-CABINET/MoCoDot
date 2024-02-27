//
//  KoreanMorse.swift
//  MorseCode
//
//  Created by 준우의 MacBook 16 on 2/25/24.
//

import Foundation

struct KoreanMorse: MorseProtocol {
    var alphabetName: String
    var morseCode: String
    var isChoSung: Bool // 초성 여부
    var isJungSung: Bool // 중성 여부
    var isJongSung: Bool // 종성 여부
}

extension KoreanMorse {
    static let koreanMorseChosungList: [KoreanMorse] = [
        // 초성
        KoreanMorse(alphabetName: "ㄱ", morseCode: ".-..", isChoSung: true, isJungSung: false, isJongSung: false), // 0
        KoreanMorse(alphabetName: "ㄲ", morseCode: ".-.. .-..", isChoSung: true, isJungSung: false, isJongSung: false), // 1
        KoreanMorse(alphabetName: "ㄴ", morseCode: "..-.", isChoSung: true, isJungSung: false, isJongSung: false), // 2
        KoreanMorse(alphabetName: "ㄷ", morseCode: "-...", isChoSung: true, isJungSung: false, isJongSung: false), // 3
        KoreanMorse(alphabetName: "ㄸ", morseCode: "-... -...", isChoSung: true, isJungSung: false, isJongSung: false), // 4
        KoreanMorse(alphabetName: "ㄹ", morseCode: "...-", isChoSung: true, isJungSung: false, isJongSung: false), // 5
        KoreanMorse(alphabetName: "ㅁ", morseCode: "--", isChoSung: true, isJungSung: false, isJongSung: false), // 6
        KoreanMorse(alphabetName: "ㅂ", morseCode: ".--", isChoSung: true, isJungSung: false, isJongSung: false), // 7
        KoreanMorse(alphabetName: "ㅃ", morseCode: ".-- .--", isChoSung: true, isJungSung: false, isJongSung: false), // 8
        KoreanMorse(alphabetName: "ㅅ", morseCode: "--.", isChoSung: true, isJungSung: false, isJongSung: false), // 9
        KoreanMorse(alphabetName: "ㅆ", morseCode: "--. --.", isChoSung: true, isJungSung: false, isJongSung: false), // 10
        KoreanMorse(alphabetName: "ㅇ", morseCode: "-.-", isChoSung: true, isJungSung: false, isJongSung: false), // 11
        KoreanMorse(alphabetName: "ㅈ", morseCode: ".--.", isChoSung: true, isJungSung: false, isJongSung: false), // 12
        KoreanMorse(alphabetName: "ㅉ", morseCode: ".--. .--.", isChoSung: true, isJungSung: false, isJongSung: false), // 13
        KoreanMorse(alphabetName: "ㅊ", morseCode: "-. -.", isChoSung: true, isJungSung: false, isJongSung: false), // 14
        KoreanMorse(alphabetName: "ㅋ", morseCode: "-. .-", isChoSung: true, isJungSung: false, isJongSung: false), // 15
        KoreanMorse(alphabetName: "ㅌ", morseCode: "--..", isChoSung: true, isJungSung: false, isJongSung: false), // 16
        KoreanMorse(alphabetName: "ㅍ", morseCode: "---", isChoSung: true, isJungSung: false, isJongSung: false), // 17
        KoreanMorse(alphabetName: "ㅎ", morseCode: ".---", isChoSung: true, isJungSung: false, isJongSung: false), // 18
        KoreanMorse(alphabetName: " ", morseCode: " / ", isChoSung: true, isJungSung: false, isJongSung: false), // 19
    ]

    static let koreanMorseJungsungList: [KoreanMorse] = [
        // 중성
        KoreanMorse(alphabetName: "ㅏ", morseCode: ".", isChoSung: false, isJungSung: true, isJongSung: false), // 0
        KoreanMorse(alphabetName: "ㅐ", morseCode: "--.-", isChoSung: false, isJungSung: true, isJongSung: false), // 1
        KoreanMorse(alphabetName: "ㅑ", morseCode: "..", isChoSung: false, isJungSung: true, isJongSung: false), // 2
        KoreanMorse(alphabetName: "ㅒ", morseCode: ".. ..-", isChoSung: false, isJungSung: true, isJongSung: false), // 3
        KoreanMorse(alphabetName: "ㅓ", morseCode: "-", isChoSung: false, isJungSung: true, isJongSung: false), // 4
        KoreanMorse(alphabetName: "ㅔ", morseCode: "- .--", isChoSung: false, isJungSung: true, isJongSung: false), // 5
        KoreanMorse(alphabetName: "ㅕ", morseCode: "...", isChoSung: false, isJungSung: true, isJongSung: false), // 6
        KoreanMorse(alphabetName: "ㅖ", morseCode: "... ..-", isChoSung: false, isJungSung: true, isJongSung: false), // 7
        KoreanMorse(alphabetName: "ㅗ", morseCode: ".-", isChoSung: false, isJungSung: true, isJongSung: false), // 8
        KoreanMorse(alphabetName: "ㅘ", morseCode: ".- .", isChoSung: false, isJungSung: true, isJongSung: false), // 9
        KoreanMorse(alphabetName: "ㅙ", morseCode: ".- --.-", isChoSung: false, isJungSung: true, isJongSung: false), // 10
        KoreanMorse(alphabetName: "ㅚ", morseCode: ".- ..-", isChoSung: false, isJungSung: true, isJongSung: false), // 11
        KoreanMorse(alphabetName: "ㅛ", morseCode: "-.", isChoSung: false, isJungSung: true, isJongSung: false), // 12
        KoreanMorse(alphabetName: "ㅜ", morseCode: "....", isChoSung: false, isJungSung: true, isJongSung: false), // 13
        KoreanMorse(alphabetName: "ㅝ", morseCode: ".... -", isChoSung: false, isJungSung: true, isJongSung: false), // 14
        KoreanMorse(alphabetName: "ㅞ", morseCode: ".... -.--", isChoSung: false, isJungSung: true, isJongSung: false), // 15
        KoreanMorse(alphabetName: "ㅟ", morseCode: ".... ..-", isChoSung: false, isJungSung: true, isJongSung: false), // 16
        KoreanMorse(alphabetName: "ㅠ", morseCode: ".-.", isChoSung: false, isJungSung: true, isJongSung: false), // 17
        KoreanMorse(alphabetName: "ㅡ", morseCode: "-..", isChoSung: false, isJungSung: true, isJongSung: false), // 18
        KoreanMorse(alphabetName: "ㅢ", morseCode: "-.. ..-", isChoSung: false, isJungSung: true, isJongSung: false), // 19
        KoreanMorse(alphabetName: "ㅣ", morseCode: "..-", isChoSung: false, isJungSung: true, isJongSung: false), // 20
        KoreanMorse(alphabetName: " ", morseCode: " / ", isChoSung: false, isJungSung: true, isJongSung: false), // 21
    ]

    static let koreanMorseJongSungList: [KoreanMorse] = [
        // 종성
        KoreanMorse(alphabetName: "ㄱ", morseCode: "-.--", isChoSung: false, isJungSung: false, isJongSung: true), // 0
        KoreanMorse(alphabetName: "ㄲ", morseCode: "-.---.--", isChoSung: false, isJungSung: false, isJongSung: true), // 1
        KoreanMorse(alphabetName: "ㄱㅅ", morseCode: "-.----.", isChoSung: false, isJungSung: false, isJongSung: true), // 2
        KoreanMorse(alphabetName: "ㄴ", morseCode: "..-.", isChoSung: false, isJungSung: false, isJongSung: true), // 3
        KoreanMorse(alphabetName: "ㄴㅈ", morseCode: "..-..--.", isChoSung: false, isJungSung: false, isJongSung: true), // 4
        KoreanMorse(alphabetName: "ㄴㅎ", morseCode: "..-..---", isChoSung: false, isJungSung: false, isJongSung: true), // 5
        KoreanMorse(alphabetName: "ㄷ", morseCode: "-...", isChoSung: false, isJungSung: false, isJongSung: true), // 6
        KoreanMorse(alphabetName: "ㄹ", morseCode: "...-", isChoSung: false, isJungSung: false, isJongSung: true), // 7
        KoreanMorse(alphabetName: "ㄹㄱ", morseCode: "...--.--", isChoSung: false, isJungSung: false, isJongSung: true), // 8
        KoreanMorse(alphabetName: "ㄹㅁ", morseCode: "...---", isChoSung: false, isJungSung: false, isJongSung: true), // 9
        KoreanMorse(alphabetName: "ㄹㅂ", morseCode: "...-.--", isChoSung: false, isJungSung: false, isJongSung: true), // 10
        KoreanMorse(alphabetName: "ㄹㅅ", morseCode: "...---.", isChoSung: false, isJungSung: false, isJongSung: false), // 11
        KoreanMorse(alphabetName: "ㄹㅌ", morseCode: "...---..", isChoSung: false, isJungSung: false, isJongSung: true), // 12
        KoreanMorse(alphabetName: "ㄹㅍ", morseCode: "...----", isChoSung: false, isJungSung: false, isJongSung: true), // 13
        KoreanMorse(alphabetName: "ㄹㅎ", morseCode: "...-.---", isChoSung: false, isJungSung: false, isJongSung: true), // 14
        KoreanMorse(alphabetName: "ㅁ", morseCode: "--", isChoSung: false, isJungSung: false, isJongSung: true), // 15
        KoreanMorse(alphabetName: "ㅂ", morseCode: ".--", isChoSung: false, isJungSung: false, isJongSung: true), // 16
        KoreanMorse(alphabetName: "ㅂㅅ", morseCode: ".----.", isChoSung: false, isJungSung: false, isJongSung: true), // 17
        KoreanMorse(alphabetName: "ㅅ", morseCode: "--.", isChoSung: false, isJungSung: false, isJongSung: true), // 18
        KoreanMorse(alphabetName: "ㅆ", morseCode: "--.--.", isChoSung: false, isJungSung: false, isJongSung: true), // 19
        KoreanMorse(alphabetName: "ㅇ", morseCode: "-.-", isChoSung: false, isJungSung: false, isJongSung: true), // 20
        KoreanMorse(alphabetName: "ㅈ", morseCode: ".--.", isChoSung: false, isJungSung: false, isJongSung: true), // 21
        KoreanMorse(alphabetName: "ㅊ", morseCode: "-.-.", isChoSung: false, isJungSung: false, isJongSung: true), // 22
        KoreanMorse(alphabetName: "ㅋ", morseCode: "-..-", isChoSung: false, isJungSung: false, isJongSung: true), // 23
        KoreanMorse(alphabetName: "ㅌ", morseCode: "--..", isChoSung: false, isJungSung: false, isJongSung: true), // 24
        KoreanMorse(alphabetName: "ㅍ", morseCode: "---", isChoSung: false, isJungSung: false, isJongSung: true), // 25
        KoreanMorse(alphabetName: "ㅎ", morseCode: ".---", isChoSung: false, isJungSung: false, isJongSung: true), // 26
        KoreanMorse(alphabetName: " ", morseCode: "/", isChoSung: false, isJungSung: false, isJongSung: true), // 27
    ]
}
