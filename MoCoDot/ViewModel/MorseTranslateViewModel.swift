//
//  MainViewModel.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Combine
import Foundation

final class MorseTranslateViewModel {
    let translateService: EnglishToMorseTranslateProtocol!

    var isTappedPublisher = CurrentValueSubject<Bool, Never>(false)
    var placeholderPublisher = CurrentValueSubject<String, Never>("English")
    var morsePlaceholderPublisher = CurrentValueSubject<String, Never>("모스코드")

    var subscriptions = Set<AnyCancellable>()

    private var isToggle: Bool = false
    var morsePlaceholder = "모스코드"
    var placeholder = "English"

    init(translateService: EnglishToMorseTranslateProtocol!) {
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

    func changeIsToggle() {
        isToggle.toggle()
        isTappedPublisher.send(isToggle)
    }

    func changePlaceholder(at str: String) {
        placeholder = str
        placeholderPublisher.send(str)
    }
}
