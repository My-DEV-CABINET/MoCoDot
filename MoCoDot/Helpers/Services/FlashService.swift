//
//  FlashService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Combine
import Foundation

final class FlashService: FlashServiceProtocol {
    var avDevice: AVCaptureDevice?
    private var flashControlTask: Task<Void, Never>?
    var flashEndSignPublishser: PassthroughSubject<Bool, Never> = .init()

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
        flashControlTask?.cancel()

        flashControlTask = Task {
            for i in inputTexts.enumerated() {
                if flashControlTask?.isCancelled == true {
                    flashControlTask?.cancel()
                    toggleTorch(on: false)
                    return
                }

                toggleTorch(on: false)
                Thread.sleep(forTimeInterval: 0.5)
                print("#### \(i)")
                if i.element == "." {
                    toggleTorch(on: true)
                    Thread.sleep(forTimeInterval: 0.5)

                } else if i.element == "-" {
                    toggleTorch(on: true)
                    Thread.sleep(forTimeInterval: 1.5)

                } else if i.element == " " && i.offset < inputTexts.count - 1 {
                    toggleTorch(on: false)
                    Thread.sleep(forTimeInterval: 1.0)
                    continue
                } else {
                    continue
                }
            }
            toggleTorch(on: false)
            flashEndSignPublishser.send(true)
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
        flashControlTask?.cancel()
        toggleTorch(on: false)
    }
}
