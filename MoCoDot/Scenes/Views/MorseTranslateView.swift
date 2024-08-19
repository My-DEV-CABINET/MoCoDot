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
    private var nationalFlagImage: UIImageView = .init(frame: .zero) // 번역할 언어의 국가 이미지
    private var nationalLb: UILabel = .init(frame: .zero) // 번역할 언어의 국가명
    private var directionImage: UIImageView = .init(frame: .zero) // -> 방향표 이미지
    private var morseGuideLb: UILabel = .init(frame: .zero) // 모스코드명 표시
    private var morseImage: UIImageView = .init(frame: .zero) // 모스코드앱 이미지

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
    private func addView() {}

    /// ScrollView & Scaffold View Autolayout 처리
    private func confirmScaffold() {}

    /// BaseView Autolayout 처리
    private func confirmBaseView() {}

    /// Google Add View Autolayout 처리
    private func confirmAdView() {
        // adView
        // TODO: Google 광고 등록
    }

    /// Language Guide View Autolayout 처리
    private func confirmGuideView() {}

    /// Input View Autolayout 처리
    private func confirmInputView() {}

    /// Output View Autolayout 처리
    private func confirmOutputView() {}
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
