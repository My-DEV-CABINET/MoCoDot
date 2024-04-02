//
//  MorseTranslateCoordinator.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import UIKit

// MARK: - MorseTranslateCoordinator

final class MorseTranslateCoordinator: Coordinator {
    let container = DIContainer.shared
    var childCoordinators: [Coordinator] = []
    var delegate: MorseTranslateCoordinatorDelegate?

    private var navigationController: UINavigationController!

    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = MorseTranslateVC()
        vc.delegate = self

        // 영어 <-> 모스코드 번역 서비스
        let englishTranslateService = self.container.resolve(type: EnglishToMorseTranslateProtocol.self)!
        // 한글 <-> 모스코드 번역 서비스
        let koreanTranslateService = self.container.resolve(type: KoreanToMorseTranslateProtocol.self)!
        // 모스코드 소리 재생 서비스
        let soundService = self.container.resolve(type: SoundServiceProtocol.self)!
        // 핸드폰 불빛 On/Off 서비스
        let flashService = self.container.resolve(type: FlashServiceProtocol.self)!
        // 음성 인식 서비스
        let voiceRecognitionService = self.container.resolve(type: VoiceRecognitionServiceProtocol.self)!

        #if DEVELOPMENT
        // 핸드폰 진동 On/Off 서비스
        let tapticService = self.container.resolve(type: TapticServiceProtocol.self)!
        #else
        // MockUP
        let tapticService = self.container.resolve(type: TapticServiceProtocol.self)!
        #endif

        vc.viewModel = MorseTranslateViewModel(
            englishTranslateService: englishTranslateService,
            koreanTranslateService: koreanTranslateService,
            soundService: soundService,
            flashService: flashService,
            tapticService: tapticService,
            voiceRecognitionService: voiceRecognitionService
        )

        self.navigationController.viewControllers = [vc]
    }
}

extension MorseTranslateCoordinator: MorseTranslateVCDelegate {
    func showMorseList() {
        self.delegate?.didTappedShowMorseList(self)
    }
}
