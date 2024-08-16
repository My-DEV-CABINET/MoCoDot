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
    // 광고 뷰
    private var adView: UIView!

    // 언어 -> 모스코드 표시 뷰
    private var guideView: UIView! // 뷰 누를 시, 언어 변경 페이지 표시

    // 사용자 입력 뷰
    private var inputBaseView: UIView!
    private var inputTextView: UITextView! // 사용자 텍스트 입력
    private var listenBtn: UIButton! // 사용자 음성 -> Text 입력(STT)
    private var voiceBtn: UIButton! // 사용자 Text 입력 -> 음성 출력(TTS)
    private var clearBtn: UIButton! // 사용자 입력 초기화
    private var translateBtn: UIButton! // Input Text -> Morse Code, 버튼색은 해당 언어 나라 국기

    // 모스코드 출력 결과 뷰
    private var outputBaseView: UIView!
    private var outputMorseLb: UILabel!
    private var speakBtn: UIButton! // 모스코드 재생 버튼
    private var bookmarkBtn: UIButton! // 변환된 모스코드 북마크 버튼, 입력값과 출력값 둘 다 같이 저장
    private var copyBtn: UIButton! // 출력된 모스코드 복사 버튼

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
        confirmBaseView()
        confirmAdView()
        confirmGuideView()
        confirmInputView()
        confirmOutputView()
    }

    /// View 등록
    private func addView() {
        [adView, guideView, inputBaseView, outputBaseView].forEach { view.addSubview($0) }
        [inputTextView, listenBtn, voiceBtn, clearBtn, translateBtn].forEach { inputBaseView.addSubview($0) }
        [outputMorseLb, speakBtn, bookmarkBtn, copyBtn].forEach { outputBaseView.addSubview($0) }
    }

    /// BaseView Autolayout 처리
    private func confirmBaseView() {
        // adView, guideView, inputBaseView, outputBaseView
    }

    /// Google Add View Autolayout 처리
    private func confirmAdView() {
        // adView
    }

    /// Language Guide View Autolayout 처리
    private func confirmGuideView() {
        // guideView
    }

    /// Input View Autolayout 처리
    private func confirmInputView() {
        // inputTextView, listenBtn, voiceBtn, clearBtn, translateBtn
    }

    /// Output View Autolayout 처리
    private func confirmOutputView() {
        // outputMorseLb, speakBtn, bookmarkBtn, copyBtn
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
