//
//  FlashService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

class FlashService: FlashServiceProtocol {
    var avDevice: AVCaptureDevice

    init() {
        avDevice = AVCaptureDevice.default(for: .video)!
    }

    func generatingMorseCodeFlashlight(at inputTexts: String) {
        for i in inputTexts {
            if i == "." {
                toggleTorch(on: true)
                Thread.sleep(forTimeInterval: 1.0)
            }

            toggleTorch(on: false)
            Thread.sleep(forTimeInterval: 1.0)
        }
    }

    func toggleTorch(on: Bool) {
        if avDevice.hasTorch {
            do {
                try avDevice.lockForConfiguration()
                if on {
                    avDevice.torchMode = .on
                } else {
                    avDevice.torchMode = .off
                }
            } catch {
                print("Error : \(error.localizedDescription)")
            }
        }
    }
}
