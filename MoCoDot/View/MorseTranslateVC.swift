//
//  MainViewController.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import AVFoundation
import Combine
import UIKit

import SnapKit

final class MorseTranslateVC: UIViewController {
    var viewModel: MorseTranslateViewModel!

    // 상단 UI들
    private let translateLanguageButton = CustomButton(frame: .zero) // 한/영 언어 변환 버튼
    private let modeImageView = CustomButton(frame: .zero) // 현재 모드 이미지
    private let modeSwitch = UISwitch(frame: .zero) // 모드 변경 스위치
    private let showMorseListButton = CustomButton(frame: .zero) // 모스부호 리스트로 이동하는 버튼

    // 기본 UI 뷰
    private let languageView = CustomTextView(frame: .zero) // 한/영 뷰
    private let morseCodeView = CustomTextView(frame: .zero) // 모스코드 변환 뷰
    private let changPositionViewButton = CustomButton(frame: .zero) // Language <-> Morse 뷰 전환 버튼(예정..)
    private let translateButton = CustomButton(frame: .zero) // 변환 버튼

    // MARK: - Language View 버튼 모아놓는 스택뷰

    private let languageFloatingStackView = CustomStackView(frame: .zero)

    private let languageFloatingButton = CustomButton(frame: .zero)
    private let languageClearButton = CustomButton(frame: .zero) // Input & MorseCode View 내용 동시 삭제
    private let languageVoiceRecognitionButton = CustomButton(frame: .zero) // 음성 인식 Input 버튼

    // MARK: - MorseCode View 버튼 모아놓는 스택뷰

    private let morseFloatingStackView = CustomStackView(frame: .zero)

    private let morseTapticButton = CustomButton(frame: .zero) // 진동 버튼
    private let morseFlashButton = CustomButton(frame: .zero) // 라이트 버튼
    private let morseSoundButton = CustomButton(frame: .zero) // 소리 버튼
    private let morseFloatingButton = CustomButton(frame: .zero) // 재생 버튼
}

// MARK: - View Life Cycle

extension MorseTranslateVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        viewModel.touchEndView()
    }
}

// MARK: - Setup UI

extension MorseTranslateVC {
    private func setupUI() {
        view.backgroundColor = UIType.background.uiColor(forMode: ModeManager.shared.currentMode)
        addView()

        // 상단 버튼
        createTranslateLanguageButton()
        createModeImageView()
        createModeSwitch()

        // 기본 베이스 UI 들
        createLanguageView()
        createChangeViewPositionButton()
        createMorseView()
        createTranslateButton()

        // InputView 안 UI 들
        createLanguageButtonStackView()
        createClearLanguageButton()
        creatVoiceRecognitionButton()
        createLanguageViewMenuButton()

        // MorseView 안 UI 들
        createMorseCodeStackView()
        createTapticButton()
        createFlashButton()
        createSoundButton()
        createPlayButton()
    }

    private func addView() {
        // MARK: - View 에 등록

        for item in [translateLanguageButton, modeImageView, modeSwitch, showMorseListButton, languageView, morseCodeView, changPositionViewButton, translateButton, morseFloatingStackView, languageFloatingStackView] {
            view.addSubview(item)
        }

        // MARK: - InputView 에 등록

        for button in [languageClearButton, languageVoiceRecognitionButton, languageFloatingButton] {
            languageFloatingStackView.addArrangedSubview(button)
        }

        // MARK: - MorseCodeView 에 등록

        for item in [morseTapticButton, morseFlashButton, morseSoundButton, morseFloatingButton] {
            morseFloatingStackView.addArrangedSubview(item)
        }
    }
}

// MARK: - ViewModel Binding

extension MorseTranslateVC {
    private func bind() {
        modeSwitchBind()

        languageFloatingButtonBind()
        languagePlaceholderBind()

        morseFloatingButtonBind()
        morsePlaceholderBind()

        showLanguageButtonMenuBind()
        showMorseButtonMenuBind()

        tapticServiceBind()
        flashServiceBind()
        soundServiceObserving()

        voiceServiceCompleteBind()
    }

    private func voiceServiceCompleteBind() {
        viewModel.voiceRecognitionService.completeEvent
            .receive(on: RunLoop.main)
            .sink { result in
                self.languageView.text = result
                self.languageView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
            }
            .store(in: &viewModel.subscriptions)
    }

    private func modeSwitchBind() {
        viewModel.switchEventPublisher
            .receive(on: RunLoop.main)
            .sink { b in
                ModeManager.shared.changeMode(b)
                var image = b ? UIImage(systemName: "sun.max") : UIImage(systemName: "moon.stars")
                self.modeImageView.setImage(image, for: .normal)
                self.modeImageView.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                self.view.backgroundColor = UIType.background.uiColor(forMode: ModeManager.shared.currentMode)
                self.translateLanguageButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.languageView.backgroundColor = UIType.view.uiColor(forMode: ModeManager.shared.currentMode)

                if self.languageView.text == self.viewModel.languagePlaceholder {
                    self.languageView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)

                } else {
                    self.languageView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
                }

                self.changPositionViewButton.tintColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                self.morseCodeView.backgroundColor = UIType.view.uiColor(forMode: ModeManager.shared.currentMode)

                if self.morseCodeView.text == self.viewModel.morsePlaceholder {
                    self.morseCodeView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
                } else {
                    self.morseCodeView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
                }

                self.translateLanguageButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.translateButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                self.languageClearButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.languageVoiceRecognitionButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.languageFloatingButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                self.morseTapticButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.morseFlashButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.morseSoundButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                self.morseFloatingButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
            }
            .store(in: &viewModel.subscriptions)
    }

    private func languagePlaceholderBind() {
        viewModel.languagePlaceholderPublisher
            .receive(on: RunLoop.main)
            .sink { str in
                self.languageView.text = str
            }
            .store(in: &viewModel.subscriptions)
    }

    private func morsePlaceholderBind() {
        viewModel.morsePlaceholderPublisher
            .receive(on: RunLoop.main)
            .sink { str in
                self.morseCodeView.text = str
            }
            .store(in: &viewModel.subscriptions)
    }

    private func languageFloatingButtonBind() {
        viewModel.tapLanguageFloatingButtonsPublisher
            .receive(on: RunLoop.main)
            .sink { button in
                print("#### \(button.description)")
                if button == self.languageClearButton {
                    if button.backgroundColor == UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode) {
                        button.backgroundColor = UIType.selectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.languageVoiceRecognitionButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                        self.languageView.text = nil
                        self.viewModel.touchEndView()
                        self.viewModel.stopRecording()

                        button.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                    }
                } else if button == self.languageVoiceRecognitionButton {
                    if button.backgroundColor == UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode) {
                        button.backgroundColor = UIType.selectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.languageClearButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                        self.languageView.text = "말해 보세요. 듣고 있어요!!"

                        DispatchQueue.main.async {
                            self.viewModel.startRecording()
                        }

                    } else {
                        self.viewModel.stopRecording()
                        button.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                    }
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func morseFloatingButtonBind() {
        viewModel.tapMorseFloatingButtonsPublisher
            .receive(on: RunLoop.main)
            .sink { button in
                if button == self.morseTapticButton {
                    if button.backgroundColor == UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode) {
                        button.backgroundColor = UIType.selectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseFlashButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseSoundButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                        self.viewModel.playHaptic(at: self.morseCodeView.text)
                        self.viewModel.toggleFlashOff()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.stopHaptic()
                        button.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                    }
                } else if button == self.morseFlashButton {
                    if button.backgroundColor == UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode) {
                        button.backgroundColor = UIType.selectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseTapticButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseSoundButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                        self.viewModel.generatingMorseCodeFlashlight(at: self.morseCodeView.text)
                        self.viewModel.stopHaptic()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.toggleFlashOff()
                        button.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                    }
                } else {
                    if button.backgroundColor == UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode) {
                        button.backgroundColor = UIType.selectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseTapticButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                        self.morseFlashButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

                        self.viewModel.generatingMorseCodeSounds(at: self.morseCodeView.text)
                        self.viewModel.stopHaptic()
                        self.viewModel.toggleFlashOff()

                    } else {
                        self.viewModel.pauseMorseCodeSounds()
                        button.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                    }
                }
            }.store(in: &viewModel.subscriptions)
    }

    private func tapticServiceBind() {
        viewModel.tapticService.tapticEndSignPublisher
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.morseTapticButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func flashServiceBind() {
        viewModel.flashService.flashEndSignPublishser
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.morseFlashButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func soundServiceObserving() {
        // SoundService 의 Player 가 끝났는지 관측
        NotificationCenter.default
            .addObserver(
                forName: AVPlayerItem.didPlayToEndTimeNotification,
                object: viewModel.soundService.player.currentItem,
                queue: .main)
        { _ in
            // CurrentItem 이 [CurrentItem]의 마지막 배열과 같으면, 모스코드 재생이 종료된 것으로 간주하여, 버튼 색상 변경
            if self.viewModel.soundService.player.currentItem == self.viewModel.soundService.player.items().last {
                self.morseSoundButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
            }
        }
    }

    private func showLanguageButtonMenuBind() {
        lazy var buttons: [UIButton] = [self.languageClearButton, self.languageVoiceRecognitionButton]

        viewModel.showLanguageButtonMenuPublisher
            .receive(on: RunLoop.main)
            .sink { isTapped in
                self.rotateMorseButton(isTapped, tag: 0)

                if isTapped == true {
                    buttons.forEach { [weak self] button in
                        button.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1)
                        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
                            button.layer.transform = CATransform3DIdentity
                            button.alpha = 1
                        }
                        self?.view.layoutIfNeeded()
                    }
                } else {
                    for button in buttons.reversed() {
                        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
                            button.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1)
                            button.alpha = 0
                        }
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func showMorseButtonMenuBind() {
        lazy var buttons: [UIButton] = [self.morseTapticButton, self.morseFlashButton, self.morseSoundButton]

        viewModel.showMorseButtonMenuPublisher
            .receive(on: RunLoop.main)
            .sink { isTapped in
                self.rotateMorseButton(isTapped, tag: 1)
                if isTapped == true {
                    buttons.forEach { [weak self] button in
                        button.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1)
                        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
                            button.layer.transform = CATransform3DIdentity
                            button.alpha = 1
                        }
                        self?.view.layoutIfNeeded()
                    }
                } else {
                    for button in buttons.reversed() {
                        UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [.curveEaseInOut]) {
                            button.layer.transform = CATransform3DMakeScale(0.3, 0.3, 1)
                            button.alpha = 0
                        }
                        self.view.layoutIfNeeded()
                    }
                }
            }
            .store(in: &viewModel.subscriptions)
    }
}

// MARK: - 한/영 전환 버튼 제약

extension MorseTranslateVC {
    private func createTranslateLanguageButton() {
        translateLanguageButton.layer.cornerRadius = 10
        translateLanguageButton.setTitle(LanguageModel.english.type, for: .normal)
        translateLanguageButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        translateLanguageButton.titleEdgeInsets = .init(top: 0, left: 35, bottom: 0, right: 0)
        translateLanguageButton.imageEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)

        translateLanguageButton.contentVerticalAlignment = .center
        translateLanguageButton.contentHorizontalAlignment = .leading

        translateLanguageButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        translateLanguageButton.tintColor = .white
        translateLanguageButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        translateLanguageButton.showsMenuAsPrimaryAction = true

        let seletedPriority = { (action: UIAction) in
            self.translateLanguageButton.setTitle(action.title, for: .normal)

            if self.languageView.text == self.viewModel.languagePlaceholder || self.languageView.text == nil {
                self.languageView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
            } else if self.languageView.text == nil {
                self.languageView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
            } else {
                self.languageView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
            }

            self.viewModel.changePlaceholder(at: action.title)

            self.view.endEditing(true)
            self.viewModel.touchEndView()
        }

        translateLanguageButton.menu = UIMenu(children: [
            UIAction(title: LanguageModel.english.type, state: .off, handler: seletedPriority),
            UIAction(title: LanguageModel.korean.type, state: .off, handler: seletedPriority),
        ])

        translateLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(languageView.snp.top).offset(-10)
            make.leading.equalTo(languageView.snp.leading)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }
}

// MARK: - 모드 변경 스위치 제약

extension MorseTranslateVC {
    private func createModeImageView() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "sun.max", withConfiguration: imageConfig)
        modeImageView.setImage(image, for: .normal)
        modeImageView.isEnabled = true
        modeImageView.tintColor = .systemYellow
        modeImageView.layer.cornerRadius = 10
        modeImageView.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

        modeImageView.snp.makeConstraints { make in
            make.top.equalTo(translateLanguageButton.snp.top)
            make.bottom.equalTo(translateLanguageButton.snp.bottom)
            make.trailing.equalTo(translateLanguageButton.snp.trailing).offset(60)
            make.width.height.equalTo(40)
        }
    }

    private func createModeSwitch() {
        modeSwitch.isOn = ModeManager.shared.currentMode
        modeSwitch.addTarget(self, action: #selector(changeModeSwitch), for: .valueChanged)

        modeSwitch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.bottom.equalTo(languageView.snp.top).offset(-10)
            make.leading.equalTo(modeImageView.snp.trailing).offset(15)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    @objc private func changeModeSwitch(_ sender: UISwitch) {
        print("#### VC: \(sender.isOn)")
        viewModel.switchEventPublisher.send(sender.isOn)
    }
}

// MARK: - LanguageView, ⬇️ 버튼 제약 , MorseCodeView, 변환 버튼 제약

extension MorseTranslateVC {
    private func createLanguageView() {
        languageView.layer.cornerRadius = 10
        languageView.backgroundColor = UIType.view.uiColor(forMode: ModeManager.shared.currentMode)
        languageView.text = viewModel.languagePlaceholder

        languageView.tag = 1
        languageView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
        languageView.font = .systemFont(ofSize: 30, weight: .bold)
        languageView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        languageView.delegate = self

        languageView.snp.makeConstraints { make in
            make.top.equalTo(translateLanguageButton.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 3 - 30)
        }
    }

    private func createChangeViewPositionButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let buttonImage = UIImage(systemName: "arrow.down", withConfiguration: imageConfig)
        changPositionViewButton.setImage(buttonImage, for: .normal)
        changPositionViewButton.tintColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        changPositionViewButton.addTarget(self, action: #selector(didTappedChangeButton), for: .touchUpInside)

        changPositionViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 14)
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(60)
        }
    }

    private func createMorseView() {
        morseCodeView.layer.cornerRadius = 10
        morseCodeView.backgroundColor = UIType.view.uiColor(forMode: ModeManager.shared.currentMode)
        morseCodeView.text = LanguageModel.morse.type

        morseCodeView.tag = 2
        morseCodeView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
        morseCodeView.font = .systemFont(ofSize: 30, weight: .bold)
        morseCodeView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: -10)
        morseCodeView.isEditable = false

        morseCodeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 3 - 30)
        }
    }

    private func createTranslateButton() {
        translateButton.setTitle("변환하기", for: .normal)
        translateButton.titleLabel?.font = .systemFont(ofSize: 30, weight: .bold)
        translateButton.layer.cornerRadius = 10
        translateButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)

        translateButton.addTarget(self, action: #selector(didTappedTranslateButton), for: .touchUpInside)

        translateButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.height.equalTo(50)
        }
    }

    @objc private func didTappedTranslateButton(_ sender: UIButton) {
        var result = ""

        if viewModel.languagePlaceholder == LanguageModel.english.type {
            viewModel.englishReset()
            result = viewModel.requestInputTextArr(at: languageView.text)
        } else {
            viewModel.koreanReset()
            result = viewModel.translateKoreanToMorse(at: languageView.text)
        }

        print("#### \(result) || \(viewModel.languagePlaceholder)")

        if result.contains(where: { $0 == "." || $0 == "-" }) == false, (languageView.text == nil || languageView.text == viewModel.languagePlaceholder) {
            showBlankAlert()
        } else if result.contains(where: { $0 == "." || $0 == "-" }) == false, (languageView.textColor == UIType.text.uiColor(forMode: true) || languageView.textColor == UIType.text.uiColor(forMode: false)) {
            showTranslateErrorAlert()
        } else {
            morseCodeView.text = result
            morseCodeView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
        }
    }

    private func showTranslateErrorAlert() {
        let alert = UIAlertController(title: "⚠️주의", message: "입력된 언어를 찾을 수 없습니다.\n변환하고자 하는 언어를 확인해주세요.", preferredStyle: .alert)

        let confirm = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.morseCodeView.text = self.viewModel.morsePlaceholder
        })
        alert.addAction(confirm)
        present(alert, animated: true)
    }

    private func showBlankAlert() {
        let alert = UIAlertController(title: "⚠️주의", message: "모스코드로 변환할 내용을 입력하지 않았습니다.", preferredStyle: .alert)

        let confirm = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.morseCodeView.text = self.viewModel.morsePlaceholder
        })
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}

// MARK: - InputView 위에 올라가는 버튼들 제약

extension MorseTranslateVC {
    // 스택뷰
    private func createLanguageButtonStackView() {
        languageFloatingStackView.configure(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 10)

        languageFloatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(languageView.snp.bottom).offset(-10)
            make.right.equalTo(languageView.snp.right).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(170)
        }
    }

    private func createClearLanguageButton() {
        languageClearButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        languageClearButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "eraser", withConfiguration: imageConfig)
        languageClearButton.setImage(buttonImage, for: .normal)
        languageClearButton.layer.cornerRadius = 25
        languageClearButton.alpha = 0
        languageClearButton.tag = 0

        languageClearButton.addTarget(self, action: #selector(didTappedClearButton), for: .touchUpInside)

        languageClearButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func didTappedClearButton(_ sender: UIButton) {
        viewModel.changeLanguageButtonBackgroundColor(at: sender)
    }

    private func creatVoiceRecognitionButton() {
        languageVoiceRecognitionButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        languageVoiceRecognitionButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "mic", withConfiguration: imageConfig)
        languageVoiceRecognitionButton.setImage(buttonImage, for: .normal)
        languageVoiceRecognitionButton.layer.cornerRadius = 25
        languageVoiceRecognitionButton.alpha = 0
        languageVoiceRecognitionButton.tag = 1

        languageVoiceRecognitionButton.addTarget(self, action: #selector(didTapVoiceRecognitionButton), for: .touchUpInside)

        languageVoiceRecognitionButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func didTapVoiceRecognitionButton(_ sender: UIButton) {
        viewModel.changeLanguageButtonBackgroundColor(at: sender)
    }

    private func createLanguageViewMenuButton() {
        languageFloatingButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        languageFloatingButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        languageFloatingButton.setImage(buttonImage, for: .normal)
        languageFloatingButton.layer.cornerRadius = 25
        languageFloatingButton.alpha = 1

        languageFloatingButton.addTarget(self, action: #selector(willShowLanguageMenuButtons), for: .touchUpInside)

        languageFloatingButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func willShowLanguageMenuButtons(_ sender: UIButton) {
        didTapInputFloatingButton()
    }
}

// MARK: - MorseCodeView 위에 올라가는 버튼들 제약

extension MorseTranslateVC {
    // 스택뷰
    private func createMorseCodeStackView() {
        morseFloatingStackView.configure(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 10)

        morseFloatingStackView.snp.makeConstraints { make in
            make.bottom.equalTo(morseCodeView.snp.bottom).offset(-10)
            make.right.equalTo(morseCodeView.snp.right).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(230)
        }
    }

    private func createTapticButton() {
        morseTapticButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        morseTapticButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "iphone.gen1.radiowaves.left.and.right", withConfiguration: imageConfig)
        morseTapticButton.setImage(buttonImage, for: .normal)
        morseTapticButton.layer.cornerRadius = 25
        morseTapticButton.alpha = 0
        morseTapticButton.tag = 0

        morseTapticButton.addTarget(self, action: #selector(didTappedTapticButton), for: .touchUpInside)

        morseTapticButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func didTappedTapticButton(_ sender: UIButton) {
        viewModel.changeMorseButtonBackgroundColor(at: sender)
    }

    private func createFlashButton() {
        morseFlashButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        morseFlashButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "flashlight.on.fill", withConfiguration: imageConfig)
        morseFlashButton.setImage(buttonImage, for: .normal)
        morseFlashButton.layer.cornerRadius = 25
        morseFlashButton.alpha = 0
        morseFlashButton.tag = 1

        morseFlashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)

        morseFlashButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func didTappedFlashButton(_ sender: UIButton) {
        viewModel.changeMorseButtonBackgroundColor(at: sender)
    }

    private func createSoundButton() {
        morseSoundButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        morseSoundButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "speaker.wave.3", withConfiguration: imageConfig)
        morseSoundButton.setImage(buttonImage, for: .normal)
        morseSoundButton.layer.cornerRadius = 25
        morseSoundButton.alpha = 0
        morseSoundButton.tag = 2

        morseSoundButton.addTarget(self, action: #selector(didTappedSoundButton), for: .touchUpInside)

        morseSoundButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc private func didTappedSoundButton(_ sender: UIButton) {
        viewModel.changeMorseButtonBackgroundColor(at: sender)
    }

    private func createPlayButton() {
        morseFloatingButton.backgroundColor = UIType.unSelectButton.uiColor(forMode: ModeManager.shared.currentMode)
        morseFloatingButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        morseFloatingButton.setImage(buttonImage, for: .normal)
        morseFloatingButton.layer.cornerRadius = 25

        morseFloatingButton.addTarget(self, action: #selector(willShowActionsButtons), for: .touchUpInside)

        morseFloatingButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    private func didTapMorseFloatingButton() {
        viewModel.changeMorseIsToggle()
    }

    private func didTapInputFloatingButton() {
        viewModel.changeInputIsToggle()
    }

    private func rotateMorseButton(_ isTapped: Bool, tag: Int) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")

        let fromValue = isTapped ? 0 : CGFloat.pi / 4
        let toValue = isTapped ? CGFloat.pi / 4 : 0
        animation.fromValue = fromValue
        animation.toValue = toValue

        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false

        if tag == 0 {
            languageFloatingButton.layer.add(animation, forKey: nil)
        } else {
            morseFloatingButton.layer.add(animation, forKey: nil)
        }
    }

    @objc private func willShowActionsButtons(_ sender: UIButton) {
        didTapMorseFloatingButton()
    }
}

// MARK: - UITextViewDelegate

extension MorseTranslateVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.languagePlaceholder {
            textView.text = nil
            textView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
        } else if textView.text == nil {
            textView.text = nil
            textView.textColor = UIType.text.uiColor(forMode: ModeManager.shared.currentMode)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            textView.text = viewModel.languagePlaceholder
            textView.textColor = UIType.placeHolder.uiColor(forMode: ModeManager.shared.currentMode)
        }
    }
}

// MARK: - <#Section Heading#>

extension MorseTranslateVC {
    @objc private func didTappedChangeButton() {
        // To do task...
    }
}
