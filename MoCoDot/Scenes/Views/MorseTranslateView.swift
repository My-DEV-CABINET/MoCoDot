//
//  MorseTranslateView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

// Rx
import RxCocoa
import RxGesture
import RxSwift

// Autolayout
import SnapKit

// Apple
import UIKit

final class MorseTranslateView: UIViewController {
    // ScrollView & Scaffold View
    private var scrollView: UIScrollView = .init(frame: .zero)
    private var scaffoldView: UIView = .init(frame: .zero)

    // Google Ad View
    private var adView: UIView = .init(frame: .zero)

    // Guide View
    private var guideView: UIView = .init(frame: .zero) // 뷰 누를 시, 언어 변경 페이지 표시
    private var morseImage: UIImageView = .init(frame: .zero) // 모스코드앱 이미지
    private var morseGuideLb: UILabel = .init(frame: .zero) // 모스코드명 표시
    private var directionImage: UIImageView = .init(frame: .zero) // -> 방향표 이미지
    private var nationalLb: UILabel = .init(frame: .zero) // 번역할 언어의 국가명
    private var nationalFlagImage: UIImageView = .init(frame: .zero) // 번역할 언어의 국가 이미지

    // Input View
    private var inputBaseView: UIView = .init(frame: .zero)
    /// 주의사항: TextView 에서 바로 입력이 아닌, TextView 터치시, 입력 뷰 Present 할 예정
    private var inputTextView: UITextView = .init(frame: .zero)
    private var inputBtnStackView: UIStackView = .init(frame: .zero)
    private var intputSpeakerBtn: UIButton = .init(frame: .zero) // 입력된 모스코드 재생 버튼
    private var inputClearBtn: UIButton = .init(frame: .zero) // 입력된 모스코드 삭제 버튼

    // 모스코드 -> 자연어 변환 버튼
    private var translateBtn: UIButton = .init(frame: .zero)

    // Output View
    private var outputBaseView: UIView = .init(frame: .zero)
    private var outputTextView: UITextView = .init(frame: .zero)
    private var outputBtnStackView: UIStackView = .init(frame: .zero)
    private var outputSpeakerBtn: UIButton = .init(frame: .zero) // 변환된 언어 음성 출력 버튼
    private var outputBookmarkBtn: UIButton = .init(frame: .zero)
    private var outputCopyBtn: UIButton = .init(frame: .zero)

    private var disposeBag: DisposeBag!
}

// MARK: - 뷰 생명주기 메서드

extension MorseTranslateView {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // 강제로 레이아웃 업데이트
        [morseImage, nationalFlagImage].forEach { $0.layoutIfNeeded() }

        // cornerRadius 설정
        morseImage.layer.cornerRadius = morseImage.bounds.width / 2
        morseImage.clipsToBounds = true

        nationalFlagImage.layer.cornerRadius = nationalFlagImage.bounds.width / 2
        nationalFlagImage.clipsToBounds = true
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

// MARK: - 뷰 UI 관련 메서드

extension MorseTranslateView {
    /// UI 총괄 메서드
    private func setupUI() {
        addView()
        confirmScaffold()
        confirmBaseView()
        confirmAdView()
        confirmGuideView()
        confirmInputView()
        confirmOutputView()
    }

    /// View 등록
    private func addView() {
        // scrollView, scaffoldView, adView, guideView, inputBaseView, outputBaseView
        view.addSubview(scrollView)
        scrollView.addSubview(scaffoldView)

        [adView, guideView, inputBaseView, outputBaseView].forEach { scaffoldView.addSubview($0) }

        // Guide View
        [morseImage, morseGuideLb, directionImage, nationalLb, nationalFlagImage].forEach { guideView.addSubview($0) }

        // Input View
        [inputTextView, inputBtnStackView, translateBtn].forEach { inputBaseView.addSubview($0) }
        [intputSpeakerBtn, inputClearBtn].forEach { inputBtnStackView.addArrangedSubview($0) }

        // Output View
        [outputTextView, outputBtnStackView].forEach { outputBaseView.addSubview($0) }
        [outputSpeakerBtn, outputBookmarkBtn, outputCopyBtn].forEach { outputBtnStackView.addArrangedSubview($0) }
    }

    /// ScrollView & Scaffold View Autolayout 처리
    private func confirmScaffold() {
        // scrollView
        scrollView.backgroundColor = .systemBackground

        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }

        scaffoldView.backgroundColor = .systemBackground

        scaffoldView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
    }

    /// BaseView Autolayout 처리
    private func confirmBaseView() {
        // adView, guideView, inputBaseView, outputBaseView

        /// AdView
        adView.backgroundColor = .systemOrange
        adView.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)

        adView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.07)
        }

        /// GuideView
        guideView.backgroundColor = .systemGray6
        guideView.layer.cornerRadius = 10

        guideView.layer.borderColor = UIColor.systemGray5.cgColor
        guideView.layer.borderWidth = 1.0

        guideView.layer.shadowColor = UIColor.systemGray3.cgColor
        guideView.layer.shadowOpacity = 1.0
        guideView.layer.shadowRadius = 5.0
        guideView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        guideView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(adView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(view.snp.height).multipliedBy(0.08)
        }

        /// InputBaseView
        inputBaseView.backgroundColor = .systemGray6
        inputBaseView.layer.cornerRadius = 10

        inputBaseView.layer.borderColor = UIColor.systemGray5.cgColor
        inputBaseView.layer.borderWidth = 1.0

        inputBaseView.layer.shadowColor = UIColor.systemGray3.cgColor
        inputBaseView.layer.shadowOpacity = 1.0
        inputBaseView.layer.shadowRadius = 5.0
        inputBaseView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        inputBaseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }

        /// OutputBaseView
        outputBaseView.backgroundColor = .systemGray6
        outputBaseView.layer.cornerRadius = 10

        outputBaseView.layer.borderColor = UIColor.systemGray5.cgColor
        outputBaseView.layer.borderWidth = 1.0

        outputBaseView.layer.shadowColor = UIColor.systemGray3.cgColor
        outputBaseView.layer.shadowOpacity = 1.0
        outputBaseView.layer.shadowRadius = 5.0
        outputBaseView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)

        outputBaseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(inputBaseView.snp.bottom).offset(22)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)

            make.bottom.equalTo(scaffoldView.snp.bottom)
        }
    }

    /// Google Add View Autolayout 처리
    private func confirmAdView() {
        // adView
        // TODO: Google 광고 등록
    }

    /// Language Guide View Autolayout 처리
    private func confirmGuideView() {
        // morseImage, morseGuideLb, directionImage, nationalFlagImage, nationalLb

        /// Morse App Image
        morseImage.image = UIImage(systemName: "flag.circle.fill") // 임시
        morseImage.backgroundColor = .systemYellow
        morseImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        morseImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(morseImage.snp.height)
        }

        /// Morse Guide Label
        morseGuideLb.text = "Morse Code"
        morseGuideLb.adjustsFontSizeToFitWidth = true
        morseGuideLb.textAlignment = .left
        morseGuideLb.backgroundColor = .clear
        morseGuideLb.font = .systemFont(ofSize: 16, weight: .semibold)

        morseGuideLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.left.equalTo(morseImage.snp.right).offset(12)
            make.right.equalTo(directionImage.snp.left).offset(-12)
        }

        /// Direction Image
        directionImage.image = UIImage(systemName: "arrow.forward")
        directionImage.contentMode = .center
        directionImage.tintColor = .label
        directionImage.backgroundColor = .clear
        directionImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        directionImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(22)
            make.width.equalTo(directionImage.snp.height)
        }

        /// National Country Label
        nationalLb.text = "English"
        nationalLb.adjustsFontSizeToFitWidth = true
        nationalLb.textAlignment = .right
        nationalLb.backgroundColor = .clear
        nationalLb.font = .systemFont(ofSize: 16, weight: .semibold)

        nationalLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.left.equalTo(directionImage.snp.right).offset(12)
            make.right.equalTo(nationalFlagImage.snp.left).offset(-12)
        }

        /// National Flag Image
        nationalFlagImage.image = UIImage(systemName: "flag.circle.fill") // 임시
        nationalFlagImage.backgroundColor = .systemYellow
        nationalFlagImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        nationalFlagImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(nationalFlagImage.snp.height)
        }
    }

    /// Input View Autolayout 처리
    private func confirmInputView() {
        // inputTextView, inputBtnStackView, intputSpeakerBtn, inputClearBtn, translateBtn

        /// InputTextView
        inputTextView.text = "Tap TextView to Present Morse Enter View"
        inputTextView.backgroundColor = .clear
        inputTextView.font = .systemFont(ofSize: 16, weight: .regular)
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        inputTextView.isEditable = false
        inputTextView.isSelectable = false

        inputTextView.layer.masksToBounds = true
        inputTextView.layer.cornerRadius = 6

        inputTextView.layer.borderColor = UIColor.systemBackground.cgColor
        inputTextView.layer.borderWidth = 1.0

        inputTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
        }

        /// inputBtnStackView
        inputBtnStackView.backgroundColor = .clear
        inputBtnStackView.layer.masksToBounds = true
        inputBtnStackView.layer.cornerRadius = 10

        inputBtnStackView.axis = .horizontal
        inputBtnStackView.alignment = .fill // 중앙 정렬
        inputBtnStackView.distribution = .fillEqually // 내용 균등하게
        inputBtnStackView.spacing = 5
        inputBtnStackView.setContentHuggingPriority(UILayoutPriority(755), for: .vertical)

        inputBtnStackView.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(12)
            make.left.equalTo(inputTextView.snp.left)
            make.right.equalTo(translateBtn.snp.left).offset(-40)
            make.bottom.equalToSuperview().inset(12)

            make.height.equalTo(inputBtnStackView.snp.width).multipliedBy(0.2)
        }

        /// Morse Code MP3 play Button
        let speakerImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let speakerNormalImage = UIImage(systemName: "speaker.wave.2", withConfiguration: speakerImageConfiguration)
        let speakerSelectedImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: speakerImageConfiguration)

        intputSpeakerBtn.setImage(speakerNormalImage, for: .normal)
        intputSpeakerBtn.setImage(speakerSelectedImage, for: .selected)

        intputSpeakerBtn.contentMode = .scaleAspectFit
        intputSpeakerBtn.contentScaleFactor = 0.8
        intputSpeakerBtn.backgroundColor = .white
        intputSpeakerBtn.tintColor = .black

        intputSpeakerBtn.layer.masksToBounds = true
        intputSpeakerBtn.layer.cornerRadius = 10

        intputSpeakerBtn.layer.borderColor = UIColor.black.cgColor
        intputSpeakerBtn.layer.borderWidth = 2.0

        /// TextView Clear Button
        let clearImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let clearNormalImage = UIImage(systemName: "trash", withConfiguration: clearImageConfiguration)
        let clearSelectedImage = UIImage(systemName: "trash.fill", withConfiguration: clearImageConfiguration)
        inputClearBtn.setImage(clearNormalImage, for: .normal)
        inputClearBtn.setImage(clearSelectedImage, for: .selected)

        inputClearBtn.contentMode = .scaleAspectFit
        inputClearBtn.contentScaleFactor = 0.8
        inputClearBtn.backgroundColor = .white
        inputClearBtn.tintColor = .black

        inputClearBtn.layer.masksToBounds = true
        inputClearBtn.layer.cornerRadius = 10

        inputClearBtn.layer.borderColor = UIColor.black.cgColor
        inputClearBtn.layer.borderWidth = 2.0

        /// Translate Button
        var translateBtnConfig = UIButton.Configuration.plain()
        translateBtnConfig.title = "Translate"
        translateBtnConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        translateBtn.configuration = translateBtnConfig
        translateBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

        translateBtn.backgroundColor = .systemGreen
        translateBtn.tintColor = .white

        translateBtn.layer.masksToBounds = true
        translateBtn.layer.cornerRadius = 10

        translateBtn.layer.borderColor = UIColor.white.cgColor
        translateBtn.layer.borderWidth = 2.0

        translateBtn.setContentHuggingPriority(UILayoutPriority(755), for: .horizontal)

        translateBtn.snp.makeConstraints { make in
            make.top.equalTo(inputTextView.snp.bottom).offset(12)
            make.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)

            make.height.equalTo(inputBtnStackView.snp.height)
            make.width.equalTo(inputBtnStackView.snp.width).multipliedBy(0.5)
        }
    }

    /// Output View Autolayout 처리
    private func confirmOutputView() {
        // outputTextView, outputBtnStackView, outputSpeakerBtn, outputBookmarkBtn, outputCopyBtn

        /// Translated Language Output Text
        outputTextView.text = "Translated Language is Here!!"
        outputTextView.backgroundColor = .clear
        outputTextView.font = .systemFont(ofSize: 16, weight: .regular)
        outputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        outputTextView.isEditable = false
        outputTextView.isSelectable = false

        outputTextView.layer.masksToBounds = true
        outputTextView.layer.cornerRadius = 6

        outputTextView.layer.borderColor = UIColor.systemBackground.cgColor
        outputTextView.layer.borderWidth = 1.0

        outputTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
        }

        /// Output Button StackView
        outputBtnStackView.axis = .horizontal
        outputBtnStackView.alignment = .fill
        outputBtnStackView.distribution = .fillEqually
        outputBtnStackView.spacing = 5

        outputBtnStackView.backgroundColor = .clear
        outputBtnStackView.layer.masksToBounds = true
        outputBtnStackView.layer.cornerRadius = 10

        outputBtnStackView.setContentHuggingPriority(UILayoutPriority(255), for: .vertical)

        outputBtnStackView.snp.makeConstraints { make in
            make.top.equalTo(outputTextView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
            make.right.equalToSuperview().inset(12)

            make.height.equalTo(inputBtnStackView.snp.height)
            make.width.equalTo(inputBtnStackView.snp.width)
        }

        /// Language TTS Button
        let speakerImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let speakerNormalImage = UIImage(systemName: "speaker.wave.2", withConfiguration: speakerImageConfiguration)
        let speakerSelectedImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: speakerImageConfiguration)
        outputSpeakerBtn.setImage(speakerNormalImage, for: .normal)
        outputSpeakerBtn.setImage(speakerSelectedImage, for: .selected)
        outputSpeakerBtn.contentMode = .scaleAspectFit
        outputSpeakerBtn.contentScaleFactor = 0.8
        outputSpeakerBtn.backgroundColor = .white
        outputSpeakerBtn.tintColor = .black

        outputSpeakerBtn.layer.masksToBounds = true
        outputSpeakerBtn.layer.cornerRadius = 10

        outputSpeakerBtn.layer.borderColor = UIColor.black.cgColor
        outputSpeakerBtn.layer.borderWidth = 2.0

        /// Bookmark Button
        let bookmarkImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let bookmarkNormalImage = UIImage(systemName: "bookmark", withConfiguration: bookmarkImageConfiguration)
        let bookmarkSelectedImage = UIImage(systemName: "bookmark.fill", withConfiguration: bookmarkImageConfiguration)
        outputBookmarkBtn.setImage(bookmarkNormalImage, for: .normal)
        outputBookmarkBtn.setImage(bookmarkSelectedImage, for: .selected)
        outputBookmarkBtn.contentMode = .scaleAspectFit
        outputBookmarkBtn.contentScaleFactor = 0.8
        outputBookmarkBtn.backgroundColor = .white
        outputBookmarkBtn.tintColor = .black

        outputBookmarkBtn.layer.masksToBounds = true
        outputBookmarkBtn.layer.cornerRadius = 10

        outputBookmarkBtn.layer.borderColor = UIColor.black.cgColor
        outputBookmarkBtn.layer.borderWidth = 2.0

        /// Copy Board Button
        let copyImageConfiguration = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        let copyNormalImage = UIImage(systemName: "doc.on.doc", withConfiguration: copyImageConfiguration)
        let copySelectedImage = UIImage(systemName: "doc.on.doc.fill", withConfiguration: copyImageConfiguration)
        outputCopyBtn.setImage(copyNormalImage, for: .normal)
        outputCopyBtn.setImage(copySelectedImage, for: .selected)
        outputCopyBtn.contentMode = .scaleAspectFit
        outputCopyBtn.contentScaleFactor = 0.8
        outputCopyBtn.backgroundColor = .white
        outputCopyBtn.tintColor = .black

        outputCopyBtn.layer.masksToBounds = true
        outputCopyBtn.layer.cornerRadius = 10

        outputCopyBtn.layer.borderColor = UIColor.black.cgColor
        outputCopyBtn.layer.borderWidth = 2.0
    }
}

// MARK: - 뷰 바인딩 관련 메서드

extension MorseTranslateView {
    /// Bind 총괄 메서드
    private func bind() {
        viewBind()
        inputBtnBind()
        outputBtnBind()
    }

    /// View 관련 Rx 메서드
    private func viewBind() {}

    /// Input 관련 버튼 Rx 메서드
    private func inputBtnBind() {}

    /// Output 관련 버튼 Rx 메서드
    private func outputBtnBind() {}
}
