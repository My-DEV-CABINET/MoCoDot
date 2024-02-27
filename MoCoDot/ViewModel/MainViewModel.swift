//
//  MainViewModel.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Foundation

final class MainViewModel {
    let translateService: TranslateProtocol!

    init(translateService: TranslateProtocol!) {
        self.translateService = translateService
    }
}

final class EnglishTranslateService: TranslateProtocol {
    var transResult: String = ""
    var morseList: [MorseProtocol] = EnglishMorse.morseList

    func translateMorse(at inputTexts: [String]) -> String {
        for inputIndex in 0 ..< inputTexts.count {
            for morseIndex in 0 ..< morseList.count {
                if inputTexts[inputIndex] == morseList[morseIndex].alphabetName {
                    transResult += morseList[morseIndex].morseCode + " "

                    if inputTexts[inputIndex] == "\n" {
                        transResult += "\n"
                    }
                }
            }
        }

        return transResult
    }

    func reset() {
        transResult = ""
    }
}
