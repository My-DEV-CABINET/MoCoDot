//
//  TapticService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/29/24.
//

import Combine
import CoreHaptics
import Foundation

class TapticService: TapticServiceProtocol {
    var hapticEngine: CHHapticEngine?
    var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer?

    private var tapticControlTask: Task<Void, Never>?
    var tapticEndSignPublisher: PassthroughSubject<Bool, Never> = .init()

    init?() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()

        guard hapticCapability.supportsHaptics else {
            print("Haptic engine Creation Error: Not Support")
            return nil
        }

        do {
            hapticEngine = try CHHapticEngine()
        } catch {
            print("Haptic Engine Creation Error: \(error.localizedDescription)")
            return nil
        }
    }

    /// 진동 종료
    func stopHaptic() {
        do {
            tapticControlTask?.cancel()
            hapticEngine?.stop()
            try hapticAdvancedPlayer?.stop(atTime: 0)
        } catch {
            print("Failed to stopHaptic: \(error.localizedDescription)")
        }
    }

    /// 입력받은 모스코드 문자에 맞춰 진동 피드백을 주는 메서드
    /// - Parameter inputTexts: 변환된 모스코드 문자열
    func playHaptic(at inputTexts: String) {
        tapticControlTask?.cancel()

        tapticControlTask = Task {
            for i in inputTexts.enumerated() {
                if tapticControlTask?.isCancelled == true {
                    tapticControlTask?.cancel()
                    stopHaptic()
                    return
                }

                print("#### \(i)")

                do {
                    try await hapticEngine?.start()

                    let pattern: CHHapticPattern
                    let duration: TimeInterval
                    if i.element == "." {
                        pattern = try makePattern(durations: [0.5], powers: [1.0])
                        duration = 0.5
                    } else if i.element == "-" {
                        pattern = try makePattern(durations: [1.0], powers: [1.0])
                        duration = 1.0
                    } else if i.element == " " && i.offset < inputTexts.count - 1 {
                        try? await hapticEngine?.stop()
                        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5초 대기
                        continue
                    } else {
                        continue
                    }

                    let player = try hapticEngine?.makeAdvancedPlayer(with: pattern)
                    try player?.start(atTime: CHHapticTimeImmediate)
                    // 지정된 시간만큼 대기
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                } catch {
                    print("Failed to play haptic: \(error)")
                }
                // 각 패턴 사이의 기본 대기 시간
                try? await Task.sleep(nanoseconds: 500_000_000)
            }
            stopHaptic()
            tapticEndSignPublisher.send(true)
        }
    }

    func makePattern(durations: [Double], powers: [Float]) throws -> CHHapticPattern {
        var events: [CHHapticEvent] = []
        var relativeTime = 0.0

        for item in durations.enumerated() {
            let duration = item.element
            let power = powers[item.offset]

            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: power)
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)

            let params = [intensity, sharpness]

            let event = CHHapticEvent(eventType: .hapticContinuous, parameters: params, relativeTime: relativeTime, duration: duration)
            relativeTime += duration
            events.append(event)
        }

        return try CHHapticPattern(events: events, parameters: [])
    }
}
