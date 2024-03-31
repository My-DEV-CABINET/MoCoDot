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

    let translateLanguageButton = CustomButton(frame: .zero) // 한/영 언어 변환 버튼
    let textInputView = CustomTextView(frame: .zero) // 한/영 뷰
    let morseCodeView = CustomTextView(frame: .zero) // 모스코드 변환 뷰
    let changPositionViewButton = CustomButton(frame: .zero) // Input
    let translateButton = CustomButton(frame: .zero) // 변환 버튼

    // MARK: - Input View 버튼 모아놓는 스택뷰

    let inputButtonStackView = CustomStackView(frame: .zero)

    let inputViewMenuButton = CustomButton(frame: .zero)
    let clearInputButton = CustomButton(frame: .zero) // Input & MorseCode View 내용 동시 삭제
    let voiceRecognitionButton = CustomButton(frame: .zero) // 음성 인식 Input 버튼

    // MARK: - MorseCode View 버튼 모아놓는 스택뷰

    let morseCodeButtonStackView = CustomStackView(frame: .zero)

    let tapticButton = CustomButton(frame: .zero) // 진동 버튼
    let flashButton = CustomButton(frame: .zero) // 라이트 버튼
    let soundButton = CustomButton(frame: .zero) // 소리 버튼
    let playButton = CustomButton(frame: .zero) // 재생 버튼
}

extension MorseTranslateVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension MorseTranslateVC {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        addView()

        createTranslateLanguageButton()
        createInputView()
        createChangePositionViewButton()
        createOutputView()
        createTranslateButton()

        createInputButtonStackView()
        createClearInputButton()
        creatVoiceRecognitionButton()
        createInputViewMenuButton()

        createMorseCodeStackView()
        createTapticButton()
        createFlashButton()
        createSoundButton()
        createPlayButton()
    }

    private func addView() {
        // MARK: - View 에 등록

        for item in [translateLanguageButton, textInputView, morseCodeView, changPositionViewButton, translateButton, morseCodeButtonStackView, inputButtonStackView] {
            view.addSubview(item)
        }

        // MARK: - InputView 에 등록

        for button in [clearInputButton, voiceRecognitionButton, inputViewMenuButton] {
            inputButtonStackView.addArrangedSubview(button)
        }

        // MARK: - MorseCodeView 에 등록

        for item in [tapticButton, flashButton, soundButton, playButton] {
            morseCodeButtonStackView.addArrangedSubview(item)
        }
    }
}

// MARK: - ViewModel Binding

extension MorseTranslateVC {
    private func bind() {
        isTappedButtonBind()
        tapticServiceBind()
        flashServiceBind()
        soundServiceObserving()
    }

    private func isTappedButtonBind() {
        viewModel.isTappedMorseFloatingButtonsPublisher
            .receive(on: RunLoop.main)
            .sink { button in
                if button == self.tapticButton {
                    if button.backgroundColor == .systemMint {
                        button.backgroundColor = .red
                        self.flashButton.backgroundColor = .systemMint
                        self.soundButton.backgroundColor = .systemMint

                        self.viewModel.playHaptic(at: self.morseCodeView.text)
                        self.viewModel.toggleFlashOff()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.stopHaptic()
                        button.backgroundColor = .systemMint
                    }
                } else if button == self.flashButton {
                    if button.backgroundColor == .systemMint {
                        button.backgroundColor = .red
                        self.tapticButton.backgroundColor = .systemMint
                        self.soundButton.backgroundColor = .systemMint

                        self.viewModel.generatingMorseCodeFlashlight(at: self.morseCodeView.text)
                        self.viewModel.stopHaptic()
                        self.viewModel.pauseMorseCodeSounds()
                    } else {
                        self.viewModel.toggleFlashOff()
                        button.backgroundColor = .systemMint
                    }
                } else {
                    if button.backgroundColor == .systemMint {
                        button.backgroundColor = .red
                        self.tapticButton.backgroundColor = .systemMint
                        self.flashButton.backgroundColor = .systemMint

                        self.viewModel.stopHaptic()
                        self.viewModel.toggleFlashOff()

                        self.viewModel.generatingMorseCodeSounds(at: self.morseCodeView.text)

                    } else {
                        self.viewModel.pauseMorseCodeSounds()
                        button.backgroundColor = .systemMint
                    }
                }
            }.store(in: &viewModel.subscriptions)
    }

    private func tapticServiceBind() {
        viewModel.tapticService.tapticEndSignPublisher
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.tapticButton.backgroundColor = .systemMint
                }
            }
            .store(in: &viewModel.subscriptions)
    }

    private func flashServiceBind() {
        viewModel.flashService.flashEndSignPublishser
            .receive(on: RunLoop.main)
            .sink { b in
                if b {
                    self.flashButton.backgroundColor = .systemMint
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
                self.soundButton.backgroundColor = .systemMint
            }
        }
    }
}

// MARK: - InputView 위에 올라가는 버튼들 제약

extension MorseTranslateVC {
    // 스택뷰
    private func createInputButtonStackView() {
        inputButtonStackView.configure(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 10)

        inputButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(textInputView.snp.bottom).offset(-10)
            make.right.equalTo(textInputView.snp.right).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(170)
        }
    }

    private func createClearInputButton() {
        clearInputButton.backgroundColor = .systemMint
        clearInputButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "eraser", withConfiguration: imageConfig)
        clearInputButton.setImage(buttonImage, for: .normal)
        clearInputButton.layer.cornerRadius = 25
        clearInputButton.alpha = 0
        clearInputButton.tag = 0

        clearInputButton.addTarget(self, action: #selector(didTappedClearButton), for: .touchUpInside)

        clearInputButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc func didTappedClearButton(_ sender: UIButton) {
        textInputView.text = nil
    }

    private func creatVoiceRecognitionButton() {
        voiceRecognitionButton.backgroundColor = .systemMint
        voiceRecognitionButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "mic", withConfiguration: imageConfig)
        voiceRecognitionButton.setImage(buttonImage, for: .normal)
        voiceRecognitionButton.layer.cornerRadius = 25
        voiceRecognitionButton.alpha = 0
        voiceRecognitionButton.tag = 1

//        clearInputButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)

        voiceRecognitionButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    private func createInputViewMenuButton() {
        inputViewMenuButton.backgroundColor = .systemMint
        inputViewMenuButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        inputViewMenuButton.setImage(buttonImage, for: .normal)
        inputViewMenuButton.layer.cornerRadius = 25
        inputViewMenuButton.alpha = 1

        inputViewMenuButton.addTarget(self, action: #selector(willShowInputMenuButtons), for: .touchUpInside)

        inputViewMenuButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc func willShowInputMenuButtons(_ sender: UIButton) {
        lazy var buttons: [UIButton] = [self.clearInputButton, self.voiceRecognitionButton]
        didTapInputFloatingButton()

        viewModel.showInputButtonMenuPublisher
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
}

// MARK: - 기본 베이스 뷰 제약

extension MorseTranslateVC {
    private func createTranslateLanguageButton() {
        translateLanguageButton.layer.cornerRadius = 10
        translateLanguageButton.setTitle("English", for: .normal)
        translateLanguageButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        translateLanguageButton.titleEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 0)
        translateLanguageButton.imageEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)

        translateLanguageButton.contentVerticalAlignment = .center
        translateLanguageButton.contentHorizontalAlignment = .leading

        translateLanguageButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)

        translateLanguageButton.tintColor = .white
        translateLanguageButton.backgroundColor = .systemMint
        translateLanguageButton.showsMenuAsPrimaryAction = true

        let seletedPriority = { (action: UIAction) in
            self.translateLanguageButton.setTitle(action.title, for: .normal)
            self.textInputView.text = action.title
            self.textInputView.textColor = .systemGray
            self.viewModel.changePlaceholder(at: action.title)
            self.view.endEditing(true)
        }

        translateLanguageButton.menu = UIMenu(children: [
            UIAction(title: "English", state: .off, handler: seletedPriority),
            UIAction(title: "한글", state: .off, handler: seletedPriority),
        ])

        translateLanguageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(textInputView.snp.top).offset(-10)
            make.leading.equalTo(textInputView.snp.leading)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    private func createInputView() {
        textInputView.layer.cornerRadius = 10
        textInputView.backgroundColor = .systemGray5
        textInputView.text = viewModel.placeholder

        textInputView.tag = 1
        textInputView.textColor = .systemGray
        textInputView.font = .systemFont(ofSize: 30, weight: .bold)
        textInputView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textInputView.delegate = self

        textInputView.snp.makeConstraints { make in
            make.top.equalTo(translateLanguageButton.snp.bottom)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 3 - 30)
        }
    }

    private func createChangePositionViewButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let buttonImage = UIImage(systemName: "arrow.down", withConfiguration: imageConfig)
        changPositionViewButton.setImage(buttonImage, for: .normal)
        changPositionViewButton.tintColor = .systemMint
        changPositionViewButton.addTarget(self, action: #selector(didTappedChangeButton), for: .touchUpInside)

        changPositionViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 14)
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(60)
        }
    }

    private func createOutputView() {
        morseCodeView.layer.cornerRadius = 10
        morseCodeView.backgroundColor = .systemGray5
        morseCodeView.text = "모스코드"

        viewModel.morsePlaceholderPublisher
            .receive(on: RunLoop.main)
            .sink { str in
                self.morseCodeView.text = str
            }
            .store(in: &viewModel.subscriptions)

        morseCodeView.tag = 2
        morseCodeView.textColor = .systemGray
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
        translateButton.backgroundColor = .systemMint
        translateButton.addTarget(self, action: #selector(didTappedTranslateButton), for: .touchUpInside)

        translateButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-15)
            make.height.equalTo(50)
        }
    }

    // MARK: - MorseCodeView 위에 올라가는 버튼들 제약

    // 스택뷰
    private func createMorseCodeStackView() {
        morseCodeButtonStackView.configure(axis: .horizontal, alignment: .fill, distribution: .fillEqually, spacing: 10)

        morseCodeButtonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(morseCodeView.snp.bottom).offset(-10)
            make.right.equalTo(morseCodeView.snp.right).offset(-10)
            make.height.equalTo(50)
            make.width.equalTo(230)
        }
    }

    private func createTapticButton() {
        tapticButton.backgroundColor = .systemMint
        tapticButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "iphone.gen1.radiowaves.left.and.right", withConfiguration: imageConfig)
        tapticButton.setImage(buttonImage, for: .normal)
        tapticButton.layer.cornerRadius = 25
        tapticButton.alpha = 0
        tapticButton.tag = 0

        tapticButton.addTarget(self, action: #selector(didTappedTapticButton), for: .touchUpInside)

        tapticButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    #warning("Taptic Button Action")
    @objc func didTappedTapticButton(_ sender: UIButton) {
        viewModel.changeButtonBackgroundColor(at: sender)
    }

    private func createFlashButton() {
        flashButton.backgroundColor = .systemMint
        flashButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "lightbulb.fill", withConfiguration: imageConfig)
        flashButton.setImage(buttonImage, for: .normal)
        flashButton.layer.cornerRadius = 25
        flashButton.alpha = 0
        flashButton.tag = 1

        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)

        flashButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    #warning("Flash Button Action")
    @objc func didTappedFlashButton(_ sender: UIButton) {
        viewModel.changeButtonBackgroundColor(at: sender)
    }

    private func createSoundButton() {
        soundButton.backgroundColor = .systemMint
        soundButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "speaker.wave.3", withConfiguration: imageConfig)
        soundButton.setImage(buttonImage, for: .normal)
        soundButton.layer.cornerRadius = 25
        soundButton.alpha = 0
        soundButton.tag = 2

        soundButton.addTarget(self, action: #selector(didTappedSoundButton), for: .touchUpInside)

        soundButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    #warning("Sound Button Action")
    @objc func didTappedSoundButton(_ sender: UIButton) {
        viewModel.changeButtonBackgroundColor(at: sender)
    }

    private func createPlayButton() {
        playButton.backgroundColor = .systemMint
        playButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "plus", withConfiguration: imageConfig)
        playButton.setImage(buttonImage, for: .normal)
        playButton.layer.cornerRadius = 25

        playButton.addTarget(self, action: #selector(willShowActionsButtons), for: .touchUpInside)

        playButton.snp.makeConstraints { make in
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
            inputViewMenuButton.layer.add(animation, forKey: nil)
        } else {
            playButton.layer.add(animation, forKey: nil)
        }
    }

    @objc func willShowActionsButtons(_ sender: UIButton) {
        lazy var buttons: [UIButton] = [self.tapticButton, self.flashButton, self.soundButton]
        didTapMorseFloatingButton()

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

// MARK: - UITextViewDelegate

extension MorseTranslateVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == viewModel.placeholder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = viewModel.placeholder
            textView.textColor = .systemGray
        }
    }
}

extension MorseTranslateVC {
    @objc func didTappedChangeButton() {
        // To do task...
    }

    @objc func didTappedTranslateButton(_ sender: UIButton) {
        var result = ""
        viewModel.englishReset()
        viewModel.koreanReset()

        if viewModel.placeholder == LanguageModel.english.type {
            result = viewModel.requestInputTextArr(at: textInputView.text)

        } else {
            result = viewModel.translateKoreanToMorse(at: textInputView.text)
        }

        if result.contains(where: { $0 == "." || $0 == "-" }) {
            morseCodeView.text = result
        } else {
            showAlert()
        }
    }

    private func showAlert() {
        let alert = UIAlertController(title: "⚠️주의", message: "입력된 언어를 찾을 수 없습니다.\n변환하고자 하는 언어를 확인해주세요.", preferredStyle: .alert)

        let confirm = UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.morseCodeView.text = self.viewModel.morsePlaceholder
        })
        alert.addAction(confirm)
        present(alert, animated: true)
    }
}
