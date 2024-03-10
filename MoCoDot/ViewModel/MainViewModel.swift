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

    func translateMorse(at inputTexts: String) -> String {
        return translateService.translateMorse(at: inputTexts)
    }

    func reset() {
        translateService.reset()
    }

    func requestInputTextArr(at inputText: String) -> String {
        return translateService.requestInputTextArr(at: inputText)
    }
}
