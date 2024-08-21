//
//  TranslateHistoryView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

// Autolayout
import SnapKit

// Apple
import UIKit

final class TranslateHistoryView: UIViewController {
    private var tableView: UITableView = .init(frame: .zero, style: .plain)
    private var adView: UIView = .init(frame: .zero)
}

// MARK: - View Life Cycle

extension TranslateHistoryView {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        setupUI()
    }
}

// MARK: - 뷰 UI 관련 메서드

extension TranslateHistoryView {
    private func setupUI() {
        addView()
        confirmScaffoldView()
    }

    private func addView() {
        [adView, tableView].forEach { view.addSubview($0) }
    }

    private func confirmScaffoldView() {
        adView.backgroundColor = .systemPink
        adView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.left.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.07)
        }

        tableView.backgroundColor = .systemOrange

        tableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(adView.snp.bottom)
            make.left.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
}
