//
//  Extensions+UIImage.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 8/16/24.
//

import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
