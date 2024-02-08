//
//  MainViewController.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 1/11/24.
//

import SnapKit
import SwiftUI
import UIKit

final class MainViewController: UIViewController {
    var isTapped = false

//    var viewModel: MainViewModel!
    let textInputView = CustomTextView(frame: .zero) // 한/영 뷰
    let morseCodeView = CustomTextView(frame: .zero) // 모스코드 변환 뷰
    let changPositionViewButton = CustomButton(frame: .zero) // Input <-> Output 변환
    let translateButton = CustomButton(frame: .zero) // 변환 버튼
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

        [textInputView, morseCodeView, changPositionViewButton, translateButton].forEach {
            view.addSubview($0)
        }

        createInputView()
        createChangePositionViewButton()
        createOutputView()
        createTranslateButton()
    }
}

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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(6)
            make.height.equalTo(50)
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
