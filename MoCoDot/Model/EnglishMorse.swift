//
//  EnglishMorse.swift
//  MorseCode
//
//  Created by 준우의 MacBook 16 on 2/25/24.
//

import Foundation

struct EnglishMorse: MorseProtocol {
    var alphabetName: String
    var morseCode: String
}

extension EnglishMorse {
    static let morseList: [EnglishMorse] = [
        EnglishMorse(alphabetName: "A", morseCode: ".--"),
        EnglishMorse(alphabetName: "B", morseCode: "-..."),
        EnglishMorse(alphabetName: "C", morseCode: "-.-."),
        EnglishMorse(alphabetName: "D", morseCode: "-.."),
        EnglishMorse(alphabetName: "E", morseCode: "."),
        EnglishMorse(alphabetName: "F", morseCode: "..-."),
        EnglishMorse(alphabetName: "G", morseCode: "--."),
        EnglishMorse(alphabetName: "H", morseCode: "...."),
        EnglishMorse(alphabetName: "I", morseCode: ".."),
        EnglishMorse(alphabetName: "J", morseCode: ".---"),
        EnglishMorse(alphabetName: "K", morseCode: "-.-"),
        EnglishMorse(alphabetName: "L", morseCode: ".-.."),
        EnglishMorse(alphabetName: "M", morseCode: "--"),
        EnglishMorse(alphabetName: "N", morseCode: "-."),
        EnglishMorse(alphabetName: "O", morseCode: "---"),
        EnglishMorse(alphabetName: "P", morseCode: ".--."),
        EnglishMorse(alphabetName: "Q", morseCode: "--.-"),
        EnglishMorse(alphabetName: "R", morseCode: ".-."),
        EnglishMorse(alphabetName: "S", morseCode: "..."),
        EnglishMorse(alphabetName: "T", morseCode: "-"),
        EnglishMorse(alphabetName: "U", morseCode: "..-"),
        EnglishMorse(alphabetName: "V", morseCode: "...-"),
        EnglishMorse(alphabetName: "W", morseCode: ".--"),
        EnglishMorse(alphabetName: "X", morseCode: "-..-"),
        EnglishMorse(alphabetName: "Y", morseCode: "-.--"),
        EnglishMorse(alphabetName: "Z", morseCode: "--.."),
        EnglishMorse(alphabetName: "0", morseCode: "-----"),
        EnglishMorse(alphabetName: "1", morseCode: ".----"),
        EnglishMorse(alphabetName: "2", morseCode: "...--"),
        EnglishMorse(alphabetName: "3", morseCode: "...--"),
        EnglishMorse(alphabetName: "4", morseCode: "....-"),
        EnglishMorse(alphabetName: "5", morseCode: "....."),
        EnglishMorse(alphabetName: "6", morseCode: "-...."),
        EnglishMorse(alphabetName: "7", morseCode: "--..."),
        EnglishMorse(alphabetName: "8", morseCode: "---.."),
        EnglishMorse(alphabetName: "9", morseCode: "----."),
        EnglishMorse(alphabetName: " ", morseCode: "  "),
        EnglishMorse(alphabetName: "\n", morseCode: ""),
    ]
}
