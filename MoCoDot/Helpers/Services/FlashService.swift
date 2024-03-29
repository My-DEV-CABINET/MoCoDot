//
//  FlashService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

class FlashService: FlashServiceProtocol {
    var avDevice: AVCaptureDevice?

    init() {
        if let device = AVCaptureDevice.default(for: .video) {
            avDevice = device
        } else {
            print("Unable to initialize AVCaptureDevice for video")
            // 적절한 오류 처리 또는 대체 로직을 여기에 추가할 수 있습니다.
        }
    }

    /// 입력받은 모스코드에 맞춰 FlashLight On/Off 하는 메서드
    /// - Parameter inputTexts: 모스코드 문자열
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

    /// FlashLight On/Off
    /// - Parameter on: On : True // Off : False
    func toggleTorch(on: Bool) {
        if avDevice?.hasTorch == true {
            do {
                try avDevice?.lockForConfiguration()
                if on {
                    avDevice?.torchMode = .on
                } else {
                    avDevice?.torchMode = .off
                }
            } catch {
                print("Error : \(error.localizedDescription)")
            }
        }
    }

    func toggleOff() {
        avDevice?.torchMode = .off
    }
}
