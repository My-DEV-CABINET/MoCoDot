//
//  SoundServiceError.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import Foundation

enum SoundServiceError: Error {
    case invalidFileURL

    var message: String {
        switch self {
        case .invalidFileURL:
            return "Beep file URLs are not available"
        }
    }
}
