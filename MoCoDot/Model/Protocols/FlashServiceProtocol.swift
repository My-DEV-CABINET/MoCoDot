//
//  FlashServiceProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

protocol FlashServiceProtocol {
    var avDevice: AVCaptureDevice { get }

    func toggleTorch(on: Bool)
    func generatingMorseCodeFlashlight(at inputTexts: String)
    func toggleOff()
}
