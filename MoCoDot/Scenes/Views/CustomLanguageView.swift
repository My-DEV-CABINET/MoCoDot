//
//  CustomLanguageView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/21/24.
//

// Autolayout
import SnapKit

// Apple
import UIKit

final class CustomLanguageView: UIViewController {
    private var scaffoldView: UIView = .init(frame: .zero)
    private var exitBtn: UIButton = .init(frame: .zero)
    private var nationalFlagImage: UIImageView = .init(frame: .zero)
    private var nationalLanguageLb: UILabel = .init(frame: .zero)
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
}

// MARK: - 뷰 생명 메서드 모음

extension CustomLanguageView {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exitBtn.layer.cornerRadius = exitBtn.bounds.width / 2
        exitBtn.layer.masksToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

// MARK: - 뷰 UI 메서드 모음

extension CustomLanguageView {
    private func setupUI() {
        view.backgroundColor = .systemOrange
        addView()
        confirmScaffoldView()
        confirmBtn()
        confirmNationalFlag()
        confirmCollectionView()
    }

    private func addView() {
        view.addSubview(scaffoldView)
        [exitBtn, nationalFlagImage, collectionView].forEach { scaffoldView.addSubview($0) }
        nationalFlagImage.addSubview(nationalLanguageLb)
    }

    private func confirmScaffoldView() {
        scaffoldView.backgroundColor = .white
        scaffoldView.layer.cornerRadius = 10

        scaffoldView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(40)
            make.height.equalTo(scaffoldView.snp.width).multipliedBy(1.2)
        }
    }

    private func confirmBtn() {
        let exitConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold)
        let exitImage = UIImage(systemName: "xmark.circle.fill", withConfiguration: exitConfig)
        exitBtn.setImage(exitImage, for: .normal)
        exitBtn.tintColor = .systemRed

        exitBtn.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12)
            make.width.height.equalTo(40)
        }
    }

    private func confirmNationalFlag() {
        nationalFlagImage.image = UIImage(systemName: "flag")
        nationalFlagImage.backgroundColor = .systemGray
        nationalFlagImage.contentMode = .scaleAspectFill
        nationalFlagImage.layer.masksToBounds = true
        nationalFlagImage.layer.cornerRadius = 10

        nationalFlagImage.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)

        nationalFlagImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(exitBtn.snp.bottom).offset(16)
            make.left.equalTo(exitBtn.snp.left)
            make.height.equalTo(nationalFlagImage.snp.width).multipliedBy(0.6)
        }

        nationalLanguageLb.text = "English"
        nationalLanguageLb.font = .systemFont(ofSize: 32, weight: .bold)
        nationalLanguageLb.textColor = .white
        nationalLanguageLb.textAlignment = .left
        nationalLanguageLb.numberOfLines = 2

        nationalLanguageLb.backgroundColor = .systemRed

        nationalLanguageLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(-12)
            make.centerX.equalToSuperview()
            make.height.equalTo(nationalLanguageLb.snp.width).multipliedBy(0.33)
        }
    }

    private func confirmCollectionView() {
        collectionView.backgroundColor = .systemBlue
        collectionView.layer.cornerRadius = 10

        collectionView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.equalTo(nationalFlagImage.snp.left)
            make.bottom.equalToSuperview().inset(16)

            make.top.equalTo(nationalFlagImage.snp.bottom).offset(16)
        }
    }
}

// MARK: - 뷰 Bind 메서드 모음

extension CustomLanguageView {
    private func bind() {}
}
