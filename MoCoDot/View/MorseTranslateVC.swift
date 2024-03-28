//
//  MainViewController.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import Combine
import SwiftUI
import UIKit

import SnapKit

final class MorseTranslateVC: UIViewController {
    var viewModel: MorseTranslateViewModel!

    let translateLanguageButton = CustomButton(frame: .zero) // 한/영 언어 변환 버튼
    let textInputView = CustomTextView(frame: .zero) // 한/영 뷰
    let morseCodeView = CustomTextView(frame: .zero) // 모스코드 변환 뷰
    let changPositionViewButton = CustomButton(frame: .zero) // Input <-> Output 변환
    let translateButton = CustomButton(frame: .zero) // 변환 버튼

    // MARK: - 버튼 모아놓는 스택뷰

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

        createMorseCodeStackView()
        createTapticButton()
        createFlashButton()
        createSoundButton()
        createPlayButton()
    }

    private func addView() {
        // MARK: - View 에 등록

        for item in [translateLanguageButton, textInputView, morseCodeView, changPositionViewButton, translateButton] {
            view.addSubview(item)
        }

        // MARK: - MorseCodeView 에 등록

        view.addSubview(morseCodeButtonStackView)
        for item in [tapticButton, flashButton, soundButton, playButton] {
            morseCodeButtonStackView.addArrangedSubview(item)
        }
    }
}

// MARK: - Create Componenets And Make Constraints

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
        let buttonImage = UIImage(systemName: "waveform", withConfiguration: imageConfig)
        tapticButton.setImage(buttonImage, for: .normal)
        tapticButton.layer.cornerRadius = 25
        tapticButton.alpha = 0

        tapticButton.addTarget(self, action: #selector(didTappedTapticButton), for: .touchUpInside)

        tapticButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc func didTappedTapticButton(_ sender: UIButton) {
        viewModel.playHaptic(at: morseCodeView.text, durations: [0], powers: [0.5])
    }

    private func createFlashButton() {
        flashButton.backgroundColor = .systemMint
        flashButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "lightbulb.fill", withConfiguration: imageConfig)
        flashButton.setImage(buttonImage, for: .normal)
        flashButton.layer.cornerRadius = 25
        flashButton.alpha = 0

        flashButton.addTarget(self, action: #selector(didTappedFlashButton), for: .touchUpInside)

        flashButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc func didTappedFlashButton(_ sender: UIButton) {
        viewModel.generatingMorseCodeFlashlight(at: morseCodeView.text)
    }

    private func createSoundButton() {
        soundButton.backgroundColor = .systemMint
        soundButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "speaker.wave.3", withConfiguration: imageConfig)
        soundButton.setImage(buttonImage, for: .normal)
        soundButton.layer.cornerRadius = 25
        soundButton.alpha = 0

        soundButton.addTarget(self, action: #selector(didTappedSoundButton), for: .touchUpInside)

        soundButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    @objc func didTappedSoundButton(_ sender: UIButton) {
        viewModel.generatingMorseCodeSounds(at: morseCodeView.text)
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

    private func didTapFloatingButton() {
        viewModel.changeIsToggle()
    }

    private func rotateFloatingButton(_ isTapped: Bool) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")

        let fromValue = isTapped ? 0 : CGFloat.pi / 4
        let toValue = isTapped ? CGFloat.pi / 4 : 0
        animation.fromValue = fromValue
        animation.toValue = toValue

        animation.duration = 0.3
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        playButton.layer.add(animation, forKey: nil)
    }

    @objc func willShowActionsButtons(_ sender: UIButton) {
        lazy var buttons: [UIButton] = [self.tapticButton, self.flashButton, self.soundButton]
        didTapFloatingButton()

        viewModel.isTappedPublisher
            .receive(on: RunLoop.main)
            .sink { isTapped in
                self.rotateFloatingButton(isTapped)
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
//        isTapped.toggle()
//
//        if isTapped {
//            morseCodeView.snp.remakeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//                make.centerX.equalTo(view.snp.centerX)
//                make.leading.equalTo(view.snp.leading).offset(22)
//                make.height.equalTo(UIScreen.main.bounds.height / 3)
//            }
//
//            textInputView.snp.remakeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
//                make.centerX.equalTo(view.snp.centerX)
//                make.leading.equalTo(view.snp.leading).offset(22)
//                make.height.equalTo(UIScreen.main.bounds.height / 3)
//            }
//        } else {
//            textInputView.snp.remakeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//                make.centerX.equalTo(view.snp.centerX)
//                make.leading.equalTo(view.snp.leading).offset(22)
//                make.height.equalTo(UIScreen.main.bounds.height / 3)
//            }
//
//            morseCodeView.snp.remakeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
//                make.centerX.equalTo(view.snp.centerX)
//                make.leading.equalTo(view.snp.leading).offset(22)
//                make.height.equalTo(UIScreen.main.bounds.height / 3)
//            }
//        }
    }

    @objc func didTappedTranslateButton(_ sender: UIButton) {
        if viewModel.placeholder == LanguageModel.english.type {
            viewModel.englishReset()
            morseCodeView.text = viewModel.requestInputTextArr(at: textInputView.text)
        } else {
            viewModel.koreanReset()
            morseCodeView.text = viewModel.translateKoreanToMorse(at: textInputView.text)
        }
    }
}

// MARK: - SWIFT UI PREVIEWS

// #if DEBUG
// import SwiftUI
//
// @available(iOS 13, *)
// extension UIViewController {
//    private struct Preview: UIViewControllerRepresentable {
//        // this variable is used for injecting the current view controller
//        let viewController: UIViewController
//
//        func makeUIViewController(context: Context) -> UIViewController {
//            return viewController
//        }
//
//        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
//    }
//
//    func toPreview() -> some View {
//        // inject self (the current view controller) for the preview
//        Preview(viewController: self)
//    }
// }
//
// @available(iOS 13.0, *)
// struct MainViewController_Preview: PreviewProvider {
//    static var previews: some View {
//        MorseTranslateVC().toPreview()
//    }
// }
// #endif
