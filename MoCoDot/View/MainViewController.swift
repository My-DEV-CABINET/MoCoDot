//
//  MainViewController.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import SwiftUI
import UIKit

import SnapKit

final class MainViewController: UIViewController {
    var isTapped = false

//    var viewModel: MainViewModel!
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

extension MainViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension MainViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        addView()
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

        [textInputView, morseCodeView, changPositionViewButton, translateButton].forEach {
            view.addSubview($0)
        }

        // MARK: - MorseCodeView 에 등록

        morseCodeView.addSubview(morseCodeButtonStackView)
        [tapticButton, flashButton, soundButton, playButton].forEach {
            morseCodeButtonStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Create Componenets And Make Constraints

extension MainViewController {
    private func createInputView() {
        textInputView.layer.cornerRadius = 10
        textInputView.backgroundColor = .systemGray5
        textInputView.text = "한/영"
        textInputView.tag = 1

        textInputView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 3)
        }
    }

    private func createChangePositionViewButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let buttonImage = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: imageConfig)
        changPositionViewButton.setImage(buttonImage, for: .normal)
        changPositionViewButton.tintColor = .systemMint
        changPositionViewButton.addTarget(self, action: #selector(didTappedChangeButton), for: .touchUpInside)

        changPositionViewButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 6)
            make.centerX.equalTo(view.snp.centerX)
            make.height.width.equalTo(60)
        }
    }

    private func createOutputView() {
        morseCodeView.layer.cornerRadius = 10
        morseCodeView.backgroundColor = .systemGray5
        morseCodeView.text = "모스코드"
        morseCodeView.tag = 2

        morseCodeView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
            make.centerX.equalTo(view.snp.centerX)
            make.leading.equalTo(view.snp.leading).offset(22)
            make.height.equalTo(UIScreen.main.bounds.height / 3)
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
            make.bottom.equalTo(morseCodeView.snp.bottom).offset(275)
            make.right.equalTo(morseCodeView.snp.right).offset(340)
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

        tapticButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    private func createFlashButton() {
        flashButton.backgroundColor = .systemMint
        flashButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "lightbulb.fill", withConfiguration: imageConfig)
        flashButton.setImage(buttonImage, for: .normal)
        flashButton.layer.cornerRadius = 25

        flashButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    private func createSoundButton() {
        soundButton.backgroundColor = .systemMint
        soundButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "speaker", withConfiguration: imageConfig)
        soundButton.setImage(buttonImage, for: .normal)
        soundButton.layer.cornerRadius = 25

        soundButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }

    private func createPlayButton() {
        playButton.backgroundColor = .systemMint
        playButton.tintColor = .white
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
        let buttonImage = UIImage(systemName: "play.fill", withConfiguration: imageConfig)
        playButton.setImage(buttonImage, for: .normal)
        playButton.layer.cornerRadius = 25

        playButton.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
}

extension MainViewController {
    @objc func didTappedChangeButton() {
        isTapped.toggle()

        if isTapped {
            morseCodeView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.equalTo(view.snp.leading).offset(22)
                make.height.equalTo(UIScreen.main.bounds.height / 3)
            }

            textInputView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.equalTo(view.snp.leading).offset(22)
                make.height.equalTo(UIScreen.main.bounds.height / 3)
            }
        } else {
            textInputView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.equalTo(view.snp.leading).offset(22)
                make.height.equalTo(UIScreen.main.bounds.height / 3)
            }

            morseCodeView.snp.remakeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height / 3 + 72)
                make.centerX.equalTo(view.snp.centerX)
                make.leading.equalTo(view.snp.leading).offset(22)
                make.height.equalTo(UIScreen.main.bounds.height / 3)
            }
        }
    }

    @objc func didTappedTranslateButton() {
        print("#### \(#function)")
    }
}

// MARK: - SWIFT UI PREVIEWS

#if DEBUG
import SwiftUI

@available(iOS 13, *)
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        // this variable is used for injecting the current view controller
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }

    func toPreview() -> some View {
        // inject self (the current view controller) for the preview
        Preview(viewController: self)
    }
}

@available(iOS 13.0, *)
struct MainViewController_Preview: PreviewProvider {
    static var previews: some View {
        MainViewController().toPreview()
    }
}
#endif
