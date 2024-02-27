//
//  CustomStackView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/9/24.
//

import UIKit

final class CustomStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomStackView {
    func configure(axis: NSLayoutConstraint.Axis, alignment: Alignment, distribution: Distribution, spacing: CGFloat) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}
