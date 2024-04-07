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

    var delegate: MorseTranslateVCDelegate?

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

    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopRecording()
    }
}

// MARK: - Setup UI

extension MorseTranslateVC {
    private func setupUI() {
        view.backgroundColor = UIColor(named: UIType.background.type)
        addView()

        // 상단 버튼
        createTranslateLanguageButton()
        createModeImageView()
        createModeSwitch()

        createShowMorseListButton()

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

        for item in [
            translateLanguageButton,
            modeImageView,
            modeSwitch,
            showMorseListButton,
            languageView,
            morseCodeView,
            changPositionViewButton,
            translateButton,
            morseFloatingStackView,
            languageFloatingStackView,
        ] {
            view.addSubview(item)
        }

        // MARK: - InputView 에 등록

        for button in [
            languageClearButton,
            languageVoiceRecognitionButton,
            languageFloatingButton,
        ] {
            languageFloatingStackView.addArrangedSubview(button)
        }

        // MARK: - MorseCodeView 에 등록

        for item in [
            morseTapticButton,
            morseFlashButton,
            morseSoundButton,
            morseFloatingButton,
        ] {
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
                self.languageView.textColor = UIColor(named: UIType.text.type)
            }
            .store(in: &viewModel.subscriptions)
    }

    private func modeSwitchBind() {
        viewModel.switchEventPublisher
            .receive(on: RunLoop.main)
            .sink { b in
                ModeManager.shared.changeMode(b)
                let image = ModeManager.shared.currentMode ? UIImage(systemName: "sun.max") : UIImage(systemName: "moon.stars")
                self.modeImageView.setImage(image, for: .normal)

                if ModeManager.shared.currentMode == false {
                    self.overrideUserInterfaceStyle = .dark
                } else {
                    self.overrideUserInterfaceStyle = .light
                }
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
                if button == self.languageClearButton {
                    if button.backgroundColor == UIColor(named: UIType.unSelectButton.type) {
                        button.backgroundColor = UIColor(named: UIType.selectButton.type)
                        self.languageVoiceRecognitionButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.viewModel.touchEndView()

                        self.languageView.text = self.viewModel.languagePlaceholder
                        self.languageView.textColor = UIColor(named: UIType.placeHolder.type)

                        self.viewModel.stopRecording()

                        button.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.view.endEditing(true)
                    }
                } else if button == self.languageVoiceRecognitionButton {
                    if button.backgroundColor == UIColor(named: UIType.unSelectButton.type) {
                        button.backgroundColor = UIColor(named: UIType.selectButton.type)
                        self.languageClearButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.languageView.text = "말해 보세요. 듣고 있어요!!"
                        self.languageView.textColor = UIColor(named: UIType.placeHolder.type)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            self.viewModel.startRecording()
                        }

                    } else {
                        self.viewModel.stopRecording()
                        button.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
                    if button.backgroundColor == UIColor(named: UIType.unSelectButton.type) {
                        button.backgroundColor = UIColor(named: UIType.selectButton.type)
                        self.morseFlashButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                        self.morseSoundButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.viewModel.playHaptic(at: self.morseCodeView.text)
                        self.viewModel.toggleFlashOff()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.stopHaptic()
                        button.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                    }
                } else if button == self.morseFlashButton {
                    if button.backgroundColor == UIColor(named: UIType.unSelectButton.type) {
                        button.backgroundColor = UIColor(named: UIType.selectButton.type)
                        self.morseTapticButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                        self.morseSoundButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.viewModel.generatingMorseCodeFlashlight(at: self.morseCodeView.text)
                        self.viewModel.stopHaptic()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.toggleFlashOff()
                        button.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                    }
                } else {
                    if button.backgroundColor == UIColor(named: UIType.unSelectButton.type) {
                        button.backgroundColor = UIColor(named: UIType.selectButton.type)
                        self.morseTapticButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                        self.morseFlashButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

                        self.viewModel.generatingMorseCodeSounds(at: self.morseCodeView.text)
                        self.viewModel.stopHaptic()
                        self.viewModel.toggleFlashOff()

                    } else {
                        self.viewModel.pauseMorseCodeSounds()
                        button.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                    }
                }
            }.store(in: &viewModel.subscriptions)
    }

    private func tapticServiceBind() {
        viewModel.tapticService.tapticEndSignPublisher
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.morseTapticButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func flashServiceBind() {
        viewModel.flashService.flashEndSignPublishser
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.morseFlashButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
                self.morseSoundButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        translateLanguageButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
        translateLanguageButton.showsMenuAsPrimaryAction = true

        let seletedPriority = { (action: UIAction) in
            self.translateLanguageButton.setTitle(action.title, for: .normal)

            self.viewModel.changeIdentifier(action.title)

            if self.languageView.text == self.viewModel.languagePlaceholder || self.languageView.text == nil {
                self.languageView.textColor = UIColor(named: UIType.placeHolder.type)
            } else if self.languageView.text == nil {
                self.languageView.textColor = UIColor(named: UIType.text.type)
            } else {
                self.languageView.textColor = UIColor(named: UIType.placeHolder.type)
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
        modeImageView.tintColor = .white
        modeImageView.layer.cornerRadius = 10
        modeImageView.backgroundColor = UIColor(named: UIType.unSelectButton.type)

        modeImageView.snp.makeConstraints { make in
            make.top.equalTo(translateLanguageButton.snp.top)
            make.bottom.equalTo(translateLanguageButton.snp.bottom)
            make.trailing.equalTo(translateLanguageButton.snp.trailing).offset(80)
            make.width.height.equalTo(40)
        }
    }

    private func createModeSwitch() {
        modeSwitch.isOn = ModeManager.shared.currentMode
        modeSwitch.addTarget(self, action: #selector(changeModeSwitch), for: .valueChanged)

        modeSwitch.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.bottom.equalTo(languageView.snp.top).offset(-10)
            make.leading.equalTo(modeImageView.snp.trailing).offset(30)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    @objc private func changeModeSwitch(_ sender: UISwitch) {
        viewModel.switchEventPublisher.send(sender.isOn)
    }

    private func createShowMorseListButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let image = UIImage(systemName: "list.bullet", withConfiguration: imageConfig)
        showMorseListButton.setImage(image, for: .normal)
        showMorseListButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
        showMorseListButton.tintColor = .white
        showMorseListButton.layer.cornerRadius = 10

        showMorseListButton.addTarget(self, action: #selector(didTapShowMorseList), for: .touchUpInside)

        showMorseListButton.snp.makeConstraints { make in
            make.top.equalTo(modeImageView.snp.top)
            make.bottom.equalTo(modeImageView.snp.bottom)
            make.trailing.equalTo(languageView.snp.trailing)
            make.width.height.equalTo(40)
        }
    }

    @objc private func didTapShowMorseList(_ sender: UIButton) {
        delegate?.showMorseList()
    }
}

// MARK: - LanguageView, ⬇️ 버튼 제약 , MorseCodeView, 변환 버튼 제약

extension MorseTranslateVC {
    private func createLanguageView() {
        languageView.layer.cornerRadius = 10
        languageView.backgroundColor = UIColor(named: UIType.view.type)
        languageView.text = viewModel.languagePlaceholder

        languageView.tag = 1
        languageView.textColor = UIColor(named: UIType.placeHolder.type)
        languageView.font = .systemFont(ofSize: 30, weight: .bold)
        languageView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
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
        changPositionViewButton.tintColor = UIColor(named: UIType.unSelectButton.type)
        changPositionViewButton.addTarget(self, action: #selector(didTappedChangeButton), for: .touchUpInside)

        changPositionViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 14)
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(60)
        }
    }

    private func createMorseView() {
        morseCodeView.layer.cornerRadius = 10
        morseCodeView.backgroundColor = UIColor(named: UIType.view.type)
        morseCodeView.text = LanguageModel.morse.type

        morseCodeView.tag = 2
        morseCodeView.textColor = UIColor(named: UIType.placeHolder.type)
        morseCodeView.font = .systemFont(ofSize: 30, weight: .bold)
        morseCodeView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 5)
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
        translateButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)

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

        if result.contains(where: { $0 == "." || $0 == "-" }) == false, (languageView.text == nil || languageView.text == viewModel.languagePlaceholder) {
            showBlankAlert()
        } else if result.contains(where: { $0 == "." || $0 == "-" }) == false, languageView.textColor == UIColor(named: UIType.text.type) {
            showTranslateErrorAlert()
        } else {
            morseCodeView.text = result
            morseCodeView.textColor = UIColor(named: UIType.text.type)
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
        languageClearButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        languageVoiceRecognitionButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        languageFloatingButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        morseTapticButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        morseFlashButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        morseSoundButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
        morseFloatingButton.backgroundColor = UIColor(named: UIType.unSelectButton.type)
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
            textView.textColor = UIColor(named: UIType.text.type)
        } else if textView.text == nil {
            textView.text = nil
            textView.textColor = UIColor(named: UIType.text.type)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == true {
            textView.text = viewModel.languagePlaceholder
            textView.textColor = UIColor(named: UIType.placeHolder.type)
        }
    }
}

// MARK: - 작업 예정

extension MorseTranslateVC {
    @objc private func didTappedChangeButton() {
        // To do task...
    }
}
