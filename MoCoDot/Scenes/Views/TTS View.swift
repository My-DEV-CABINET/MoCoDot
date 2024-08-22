//
//  TTS View.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/21/24.
//

// Autolayout
import SnapKit

// Apple
import UIKit

final class TTSView: UIViewController {
    private var scaffoldView: UIView = .init(frame: .zero)

    private var inputBaseView: UIView = .init(frame: .zero)
    private var inputWaveView: UIView = .init(frame: .zero) // 추후, Custom Wave View 로 대체
    private var inputSignLb: UILabel = .init(frame: .zero)
    private var inputTextView: UITextView = .init(frame: .zero)

    private var timeLabel: UILabel = .init(frame: .zero)
    private var resetBtn: UIButton = .init(frame: .zero)
    private var resetLb: UILabel = .init(frame: .zero)

    private var ttsButton: UIButton = .init(frame: .zero)
    private var saveBtn: UIButton = .init(frame: .zero)
    private var saveLb: UILabel = .init(frame: .zero)
    private var exitBtn: UIButton = .init(frame: .zero)
    private var exitLb: UILabel = .init(frame: .zero)
}

// MARK: - 뷰 생명주기 메서드 모음

extension TTSView {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
