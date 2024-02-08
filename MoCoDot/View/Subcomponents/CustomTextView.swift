//
//  CustomTextView.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 2/8/24.
//

import UIKit

final class CustomTextView: UITextView {
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
