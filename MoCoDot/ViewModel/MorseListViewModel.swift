//
//  MorseListViewModel.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/2/24.
//

import Foundation

final class MorseListViewModel {
    var soundService: SoundServiceProtocol?
    var englishMorseList = EnglishMorse.morseList
    var koreanMorseList = KoreanMorse.koreanMorseList

    init(soundService: SoundServiceProtocol) {
        self.soundService = soundService
    }

    deinit {
        self.soundService = nil
    }
}

extension MorseListViewModel {
    func generatingMorseCodeSounds(_ value: String) {
        soundService?.generatingMorseCodeSounds(at: value)
    }
}
