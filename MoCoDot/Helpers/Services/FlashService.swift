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
            toggleTorch(on: false)
            Thread.sleep(forTimeInterval: 0.5)
            print("#### \(i)")
            if i == "." {
                toggleTorch(on: true)
                Thread.sleep(forTimeInterval: 0.5)

            } else if i == "-" {
                toggleTorch(on: true)
                Thread.sleep(forTimeInterval: 1.5)

            } else {
                toggleTorch(on: false)
                Thread.sleep(forTimeInterval: 1.0)
                continue
            }
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
