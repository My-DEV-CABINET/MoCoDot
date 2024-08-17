//
//  LanguageTranslateView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

// Rx
import RxCocoa
import RxSwift

// Autolayout
import SnapKit

// Apple
import UIKit

final class LanguageTranslateView: UIViewController {
    // 스크롤 뷰 & 스크롤 뷰 위에 올라가는 기본 뷰 = Scaffold
    private var scrollView: UIScrollView = .init(frame: .zero)
    private var scaffoldView: UIView = .init(frame: .zero)

    // 광고 뷰
    private var adView: UIView = .init(frame: .zero)

    // 언어 -> 모스코드 표시 뷰
    private var guideView: UIView = .init(frame: .zero) // 뷰 누를 시, 언어 변경 페이지 표시
    private var nationalFlagImage: UIImageView = .init(frame: .zero) // 번역할 언어의 국가 이미지
    private var nationalLb: UILabel = .init(frame: .zero) // 번역할 언어의 국가명
    private var directionImage: UIImageView = .init(frame: .zero) // -> 방향표 이미지
    private var morseGuideLb: UILabel = .init(frame: .zero) // 모스코드명 표시
    private var morseImage: UIImageView = .init(frame: .zero) // 모스코드앱 이미지

    // 사용자 입력 뷰
    private var inputBaseView: UIView = .init(frame: .zero)
    private var inputTextView: UITextView = .init(frame: .zero) // 사용자 텍스트 입력

    // 사용자 입력 뷰 버튼
    private var inputBtnStackView: UIStackView = .init(frame: .zero)
    private var listenBtn: UIButton = .init(frame: .zero) // 사용자 음성 -> Text 입력(STT)
    private var voiceBtn: UIButton = .init(frame: .zero) // 사용자 Text 입력 -> 음성 출력(TTS)
    private var clearBtn: UIButton = .init(frame: .zero) // 사용자 입력 초기화
    private var translateBtn: UIButton = .init(frame: .zero) // Input Text -> Morse Code, 버튼색은 해당 언어 나라 국기

    // 모스코드 출력 결과 뷰
    private var outputBaseView: UIView = .init(frame: .zero)
    private var outputMorseLb: UILabel = .init(frame: .zero)

    // 모스코드 출력 뷰 버튼
    private var outputBtnStackView: UIStackView = .init(frame: .zero)
    private var speakBtn: UIButton = .init(frame: .zero) // 모스코드 재생 버튼
    private var bookmarkBtn: UIButton = .init(frame: .zero) // 변환된 모스코드 북마크 버튼, 입력값과 출력값 둘 다 같이 저장
    private var copyBtn: UIButton = .init(frame: .zero) // 출력된 모스코드 복사 버튼

    private var disposeBag: DisposeBag!
}

// MARK: - 뷰 생명주기 메서드

extension LanguageTranslateView {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        setupUI()
        bind()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        disposeBag = DisposeBag()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
}

// MARK: - 뷰 UI 관련 메서드

extension LanguageTranslateView {
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
        view.addSubview(scrollView)
        scrollView.addSubview(scaffoldView)

        /// 기본 Scaffold View 등록
        [adView, guideView, inputBaseView, outputBaseView].forEach { scaffoldView.addSubview($0) }

        /// Guide View 등록
        [nationalFlagImage, nationalLb, directionImage, morseGuideLb, morseImage].forEach { guideView.addSubview($0) }

        /// InputBase View 등록
        [inputTextView, inputBtnStackView].forEach { inputBaseView.addSubview($0) }
        [listenBtn, voiceBtn, clearBtn].forEach { inputBtnStackView.addArrangedSubview($0) }
        inputBaseView.addSubview(translateBtn)

        /// OutputBase Veiw 등록
        [outputMorseLb, outputBtnStackView].forEach { outputBaseView.addSubview($0) }
        [speakBtn, bookmarkBtn, copyBtn].forEach { outputBtnStackView.addArrangedSubview($0) }
    }

    private func confirmScaffold() {
        // scrollView
        scrollView.backgroundColor = .systemPink

        scrollView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }

        scaffoldView.backgroundColor = .systemBlue

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
        guideView.backgroundColor = .systemOrange
        guideView.layer.cornerRadius = 10

        guideView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(adView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(view.snp.height).multipliedBy(0.08)
        }

        /// InputBaseView
        inputBaseView.backgroundColor = .systemOrange
        inputBaseView.layer.cornerRadius = 10

        inputBaseView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(guideView.snp.bottom).offset(16)
            make.left.equalToSuperview().inset(12)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }

        /// OutputBaseView
        outputBaseView.backgroundColor = .systemOrange
        outputBaseView.layer.cornerRadius = 10

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
        // nationalFlagImage, nationalLb, directionImage, morseGuideLb, morseImage

        /// NationalFlag Image
        nationalFlagImage.image = UIImage(systemName: "flag.circle.fill") // 임시
        nationalFlagImage.backgroundColor = .systemYellow
        nationalFlagImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        DispatchQueue.main.async {
            self.nationalFlagImage.layer.cornerRadius = self.nationalFlagImage.bounds.width / 2
            self.nationalFlagImage.clipsToBounds = true
        }

        nationalFlagImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(nationalFlagImage.snp.height)
        }

        /// National Name Label
        nationalLb.text = "English"
        nationalLb.adjustsFontSizeToFitWidth = true
        nationalLb.backgroundColor = .systemYellow
        nationalLb.font = .systemFont(ofSize: 16, weight: .semibold)

        nationalLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.left.equalTo(nationalFlagImage.snp.right).offset(12)
            make.right.equalTo(directionImage.snp.left).offset(-12)
        }

        /// Direction Image
        directionImage.image = UIImage(systemName: "arrow.forward")
        directionImage.backgroundColor = .systemYellow
        directionImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        directionImage.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(22)
            make.width.equalTo(directionImage.snp.height)
        }

        /// Morse Code Label
        morseGuideLb.text = "MorseCode"
        morseGuideLb.adjustsFontSizeToFitWidth = true
        morseGuideLb.backgroundColor = .systemYellow
        morseGuideLb.font = .systemFont(ofSize: 16, weight: .semibold)

        morseGuideLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(16)
            make.left.equalTo(directionImage.snp.right).offset(12)
            make.right.equalTo(morseImage.snp.left).offset(-12)
        }

        /// Morse Code App Image
        morseImage.image = UIImage(systemName: "flag.circle.fill") // 임시
        morseImage.backgroundColor = .systemYellow
        morseImage.setContentHuggingPriority(UILayoutPriority(255), for: .horizontal)

        DispatchQueue.main.async {
            self.morseImage.layer.cornerRadius = self.morseImage.bounds.width / 2
            self.morseImage.clipsToBounds = true
        }

        morseImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.top.equalToSuperview().inset(16)
            make.width.equalTo(morseImage.snp.height)
        }
    }

    /// Input View Autolayout 처리
    private func confirmInputView() {
        // inputTextView, inputBtnStackView, listenBtn, voiceBtn, clearBtn, translateBtn

        /// InputTextView
        inputTextView.text = "Enter text to translate"
        inputTextView.backgroundColor = .systemPink
        inputTextView.font = .systemFont(ofSize: 16, weight: .regular)
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        inputTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(8)
            make.left.equalToSuperview().inset(8)
        }

        /// inputBtnStackView
        inputBtnStackView.backgroundColor = .systemPink
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

        let listenImageConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let listenNormalImage = UIImage(systemName: "speaker.wave.2", withConfiguration: listenImageConfiguration)
        let listenSelectedImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: listenImageConfiguration)
        listenBtn.setImage(listenNormalImage, for: .normal)
        listenBtn.setImage(listenSelectedImage, for: .selected)
        listenBtn.contentMode = .scaleAspectFit
        listenBtn.contentScaleFactor = 0.8
        listenBtn.backgroundColor = .systemYellow

        let voiceImageConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let voiceNormalImage = UIImage(systemName: "speaker.wave.2", withConfiguration: voiceImageConfiguration)
        let voiceSelectedImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: voiceImageConfiguration)
        voiceBtn.setImage(voiceNormalImage, for: .normal)
        voiceBtn.setImage(voiceSelectedImage, for: .selected)
        voiceBtn.contentMode = .scaleAspectFit
        voiceBtn.contentScaleFactor = 0.8
        voiceBtn.backgroundColor = .systemYellow

        let clearImageConfiguration = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let clearNormalImage = UIImage(systemName: "speaker.wave.2", withConfiguration: clearImageConfiguration)
        let clearSelectedImage = UIImage(systemName: "speaker.wave.2.fill", withConfiguration: clearImageConfiguration)
        clearBtn.setImage(clearNormalImage, for: .normal)
        clearBtn.setImage(clearSelectedImage, for: .selected)
        clearBtn.contentMode = .scaleAspectFit
        clearBtn.contentScaleFactor = 0.8
        clearBtn.backgroundColor = .systemYellow

        var translateBtnConfig = UIButton.Configuration.plain()
        translateBtnConfig.title = "Translate"
        translateBtnConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        translateBtn.configuration = translateBtnConfig
        translateBtn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        translateBtn.tintColor = .white
        translateBtn.layer.cornerRadius = 10
        translateBtn.backgroundColor = .systemBlue
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
        // outputMorseLb, outputBtnStackView, speakBtn, bookmarkBtn, copyBtn
    }
}

// MARK: - 뷰 바인딩 관련 메서드

extension LanguageTranslateView {
    /// Bind 총괄 메서드
    private func bind() {
        viewBind()
        inputBtnBind()
        outputBtnBind()
    }

    private func viewBind() {
        // adView, guideView
        // adView: 광고 클릭시, 광고 페이지 이동
        // guideView: 클릭시, 언어 변경 페이지 표시
    }

    /// Input 관련 버튼 Rx 메서드
    private func inputBtnBind() {
        // listenBtn, voiceBtn, clearBtn, translateBtn
    }

    /// Output 관련 버튼 Rx 메서드
    private func outputBtnBind() {
        // speakBtn, bookmarkBtn, copyBtn
    }
}
