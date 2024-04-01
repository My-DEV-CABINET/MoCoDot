//
//  MainViewModel.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import Combine
import UIKit

final class MorseTranslateViewModel {
    // 모듈 서비스
    let englishTranslateService: EnglishToMorseTranslateProtocol
    let koreanTranslateService: KoreanToMorseTranslateProtocol
    let soundService: SoundServiceProtocol
    let flashService: FlashServiceProtocol
    let tapticService: TapticServiceProtocol

    // 스위치 이벤트 값 전달
    var switchEventPublisher = CurrentValueSubject<Bool, Never>(ModeManager.shared.currentMode)

    // Floating Button 보여주는 이벤트 전달
    var showLanguageButtonMenuPublisher = CurrentValueSubject<Bool, Never>(false)
    var showMorseButtonMenuPublisher = CurrentValueSubject<Bool, Never>(false)

    // Placeholder 전환 이벤트 전달
    var languagePlaceholderPublisher = CurrentValueSubject<String, Never>(LanguageModel.english.type)
    var morsePlaceholderPublisher = CurrentValueSubject<String, Never>(LanguageModel.morse.type)

    // 입력 버튼 감지 이벤트 전달
    var tapLanguageFloatingButtonsPublisher = PassthroughSubject<UIButton, Never>()
    var tapMorseFloatingButtonsPublisher = PassthroughSubject<UIButton, Never>()

    // 이벤트 구독 관리
    var subscriptions = Set<AnyCancellable>()

    // Floating Button 입력 Toggle
    private var languageToggle: Bool = false
    private var morseToggle: Bool = false

    // Placeholder 문구
    var languagePlaceholder = LanguageModel.english.type
    var morsePlaceholder = LanguageModel.morse.type

    init(
        englishTranslateService: EnglishToMorseTranslateProtocol,
        koreanTranslateService: KoreanToMorseTranslateProtocol,
        soundService: SoundServiceProtocol,
        flashService: FlashServiceProtocol,
        tapticService: TapticServiceProtocol
    ) {
        self.englishTranslateService = englishTranslateService
        self.koreanTranslateService = koreanTranslateService
        self.soundService = soundService
        self.flashService = flashService
        self.tapticService = tapticService
    }
}

// MARK: - EnglishToMorseTranslateProtocol Method

extension MorseTranslateViewModel {
    func requestInputTextArr(at inputText: String) -> String {
        return englishTranslateService.requestInputTextArr(at: inputText)
    }

    func englishReset() {
        englishTranslateService.reset()
    }
}

// MARK: - KoreanToMorseTranslateProtocol Method

extension MorseTranslateViewModel {
    func translateKoreanToMorse(at inputTexts: String) -> String {
        return koreanTranslateService.translateMorse(at: inputTexts)
    }

    func koreanReset() {
        koreanTranslateService.reset()
    }
}

// MARK: - SoundServiceProtocol Method

extension MorseTranslateViewModel {
    func generatingMorseCodeSounds(at message: String) {
        soundService.generatingMorseCodeSounds(at: message)
    }

    func pauseMorseCodeSounds() {
        soundService.pauseMorseCodeSounds()
    }
}

// MARK: - FlashServiceProtocol Method

extension MorseTranslateViewModel {
    func generatingMorseCodeFlashlight(at inputTexts: String) {
        flashService.generatingMorseCodeFlashlight(at: inputTexts)
    }

    func toggleFlashOff() {
        flashService.toggleOff()
    }
}

// MARK: - TapticServiceProtocol Method

extension MorseTranslateViewModel {
    func stopHaptic() {
        tapticService.stopHaptic()
    }

    func playHaptic(at inputTexts: String) {
        tapticService.playHaptic(at: inputTexts)
    }
}

// MARK: - ViewModel's Original Method

extension MorseTranslateViewModel {
    func changeInputIsToggle() {
        languageToggle.toggle()
        showLanguageButtonMenuPublisher.send(languageToggle)
    }

    func changeMorseIsToggle() {
        morseToggle.toggle()
        showMorseButtonMenuPublisher.send(morseToggle)
    }

    func changePlaceholder(at str: String) {
        languagePlaceholder = str
        languagePlaceholderPublisher.send(str)
    }

    func changeButtonBackgroundColor(at button: UIButton) {
        tapMorseFloatingButtonsPublisher.send(button)
    }

    func touchEndView() {
        if languageToggle == true {
            languageToggle = false
            showLanguageButtonMenuPublisher.send(languageToggle)
        }

        if morseToggle == true {
            morseToggle = false
            showMorseButtonMenuPublisher.send(morseToggle)
        }
    }
}
