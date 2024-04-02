//
//  SectionHeaderView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/3/24.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    static let reuseId = "HeaderView"
    var titleLabel = UILabel(frame: .zero)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        addSubview(titleLabel)
        titleLabel.textColor = UIColor(named: UIType.text.type)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)

        titleLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(contentView.snp.leading).offset(10)
        }
    }
}
