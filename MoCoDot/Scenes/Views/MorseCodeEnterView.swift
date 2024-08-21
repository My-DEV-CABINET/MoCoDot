//
//  MorseCodeEnterView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/20/24.
//

// Rx
import RxCocoa
import RxSwift

// Autolayout
import SnapKit

// Apple
import UIKit

final class MorseCodeEnterView: UIViewController {
    private var scaffoldView: UIView = .init(frame: .zero)

    private var exitBtn: UIButton = .init(frame: .zero) // 닫기 버튼
    private var resetBtn: UIButton = .init(frame: .zero) // 초기화 버튼

    private var inputBaseView: UIView = .init(frame: .zero)
    private var inputTextView: UITextView = .init(frame: .zero)

    private var inputBtnBaseView: UIView = .init(frame: .zero)
    private var inputBtnStackView: UIStackView = .init(frame: .zero)
    private var dotBtn: UIButton = .init(frame: .zero) // . 버튼
    private var dashBtn: UIButton = .init(frame: .zero) // - 버튼
    private var spaceBtn: UIButton = .init(frame: .zero) // 띄어쓰기 버튼
    private var deleteBtn: UIButton = .init(frame: .zero) // 한 글자 지우기 버튼

    private var doneBtn: UIButton = .init(frame: .zero) // 완료 버튼

    var disposeBag: DisposeBag!
}

// MARK: - 뷰 상태 관련 메서드

extension MorseCodeEnterView {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exitBtn.layer.masksToBounds = true
        exitBtn.layer.cornerRadius = exitBtn.bounds.width / 2

        resetBtn.layer.masksToBounds = true
        resetBtn.layer.cornerRadius = exitBtn.bounds.width / 2
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disposeBag = DisposeBag()
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

// MARK: - 모스코드 입력 뷰 UI 관련 메서드 모음

extension MorseCodeEnterView {
    private func setupUI() {
        addView()
        confirmScaffoldView()
        confirmInputBtn()
    }

    private func addView() {
        view.addSubview(scaffoldView)
        [exitBtn, resetBtn, inputBaseView, inputBtnBaseView, doneBtn].forEach { scaffoldView.addSubview($0) }
        inputBaseView.addSubview(inputTextView)

        inputBtnBaseView.addSubview(inputBtnStackView)
        [dotBtn, dashBtn, spaceBtn, deleteBtn].forEach { inputBtnStackView.addArrangedSubview($0) }
    }

    private func confirmScaffoldView() {
        // scaffoldView, exitBtn, resetBtn, inputBaseView, inputBtnBaseView, doneBtn
        view.backgroundColor = .clear
        scaffoldView.backgroundColor = .systemBackground
        scaffoldView.layer.masksToBounds = true
        scaffoldView.layer.cornerRadius = 10

        scaffoldView.snp.makeConstraints { make in
            make.centerX.left.bottom.equalToSuperview()
        }

        let exitImageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let exitImage = UIImage(systemName: "xmark", withConfiguration: exitImageConfig)
        exitBtn.setImage(exitImage, for: .normal)
        exitBtn.tintColor = .white
        exitBtn.backgroundColor = .systemRed

        exitBtn.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(22)
            make.height.width.equalTo(30)
        }

        let resetImageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let resetImage = UIImage(systemName: "eraser.fill", withConfiguration: resetImageConfig)
        resetBtn.setImage(resetImage, for: .normal)
        resetBtn.tintColor = .white
        resetBtn.backgroundColor = .systemOrange

        resetBtn.snp.makeConstraints { make in
            make.top.equalTo(exitBtn.snp.top)
            make.left.equalTo(exitBtn.snp.right).offset(12)
            make.height.width.equalTo(30)
        }

        inputBaseView.backgroundColor = .systemGray6
        inputBaseView.layer.cornerRadius = 10

        inputBaseView.layer.shadowColor = UIColor.systemGray3.cgColor
        inputBaseView.layer.shadowOpacity = 1.0
        inputBaseView.layer.shadowRadius = 5.0
        inputBaseView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)

        inputBaseView.snp.makeConstraints { make in
            make.top.equalTo(exitBtn.snp.bottom).offset(16)
            make.left.equalTo(exitBtn.snp.left)
            make.centerX.equalToSuperview()
            make.height.equalTo(inputBaseView.snp.width).multipliedBy(0.8)
        }

        inputTextView.text = "Enter Morse Code, Here"
        inputTextView.backgroundColor = .systemGray3.withAlphaComponent(0.5)

        inputTextView.layer.masksToBounds = true
        inputTextView.layer.cornerRadius = 10

        inputTextView.font = .systemFont(ofSize: 16, weight: .bold)
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        inputTextView.isEditable = false
        inputTextView.isSelectable = false

        inputTextView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalToSuperview().inset(16)
        }

        inputBtnBaseView.backgroundColor = .systemGray6
        inputBtnBaseView.layer.cornerRadius = 10

        inputBtnBaseView.layer.shadowColor = UIColor.systemGray3.cgColor
        inputBtnBaseView.layer.shadowOpacity = 1.0
        inputBtnBaseView.layer.shadowRadius = 5.0
        inputBtnBaseView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        inputBtnBaseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputBaseView.snp.bottom).offset(16)
            make.left.equalTo(inputBaseView.snp.left)
            make.height.equalTo(inputBtnBaseView.snp.width).multipliedBy(0.3)
        }

        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString("DONE")
        titleAttr.font = UIFont.boldSystemFont(ofSize: 22)
        config.attributedTitle = titleAttr
        config.image = UIImage(systemName: "checkmark.circle")?.withConfiguration(UIImage.SymbolConfiguration(weight: .bold))
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        config.imagePadding = 5
        doneBtn.configuration = config

        doneBtn.tintColor = .white
        doneBtn.backgroundColor = .systemRed
        doneBtn.layer.cornerRadius = 10

        doneBtn.layer.shadowColor = UIColor.systemGray3.cgColor
        doneBtn.layer.shadowOpacity = 1.0
        doneBtn.layer.shadowRadius = 5.0
        doneBtn.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        doneBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputBtnBaseView.snp.bottom).offset(16)
            make.left.equalTo(inputBtnBaseView.snp.left)
            make.height.equalTo(doneBtn.snp.width).multipliedBy(0.2)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }

    private func confirmInputBtn() {
        // inputBtnStackView, dotBtn, dashBtn, spaceBtn, deleteBtn
        inputBtnStackView.axis = .horizontal
        inputBtnStackView.alignment = .fill
        inputBtnStackView.distribution = .fillEqually
        inputBtnStackView.spacing = 5

        inputBtnStackView.backgroundColor = .clear

        inputBtnStackView.layer.masksToBounds = true
        inputBtnStackView.layer.cornerRadius = 10

        inputBtnStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.left.equalToSuperview().inset(12)
        }

        let dotImageConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        let dotImage = UIImage(systemName: "circle.fill", withConfiguration: dotImageConfig)
        dotBtn.setImage(dotImage, for: .normal)
        dotBtn.tintColor = .white
        dotBtn.backgroundColor = .systemIndigo

        dotBtn.layer.masksToBounds = true
        dotBtn.layer.cornerRadius = 10

        let dashImageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .bold)
        let dashImage = UIImage(systemName: "minus", withConfiguration: dashImageConfig)
        dashBtn.setImage(dashImage, for: .normal)
        dashBtn.tintColor = .white
        dashBtn.backgroundColor = .systemOrange

        dashBtn.layer.masksToBounds = true
        dashBtn.layer.cornerRadius = 10

        let spaceImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let spaceImage = UIImage(systemName: "space", withConfiguration: spaceImageConfig)
        spaceBtn.setImage(spaceImage, for: .normal)
        spaceBtn.tintColor = .white
        spaceBtn.backgroundColor = .systemGreen

        spaceBtn.layer.masksToBounds = true
        spaceBtn.layer.cornerRadius = 10

        let deleteImageConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        let deleteImage = UIImage(systemName: "xmark", withConfiguration: deleteImageConfig)
        deleteBtn.setImage(deleteImage, for: .normal)
        deleteBtn.tintColor = .white
        deleteBtn.backgroundColor = .systemPink

        deleteBtn.layer.masksToBounds = true
        deleteBtn.layer.cornerRadius = 10
    }
}

// MARK: - Rx Bind 관련 메서드 모음

extension MorseCodeEnterView {
    private func bind() {
        btnBind()
    }

    private func btnBind() {
        // exitBtn, resetBtn, dotBtn, dashBtn, spaceBtn, deleteBtn, doneBtn
        exitBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)

        resetBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: 초기화 버튼 눌렀다.")
            })
            .disposed(by: disposeBag)

        dotBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: . 버튼 눌렀다.")
            })
            .disposed(by: disposeBag)

        dashBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: - 버튼 눌렀다.")
            })
            .disposed(by: disposeBag)

        spaceBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: 띄우기 버튼 눌렀다.")
            })
            .disposed(by: disposeBag)

        deleteBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                print("#### 클래스명: \(String(describing: type(of: self))), 함수명: \(#function), Line: \(#line), 출력 Log: 한 글자 지우기 버튼 눌렀다.")
            })
            .disposed(by: disposeBag)

        doneBtn.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
