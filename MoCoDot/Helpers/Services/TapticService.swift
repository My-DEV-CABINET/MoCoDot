//
//  TapticService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/29/24.
//

import CoreHaptics
import Foundation

class TapticService: TapticServiceProtocol {
    var hapticEngine: CHHapticEngine
    var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer?

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

    func stopHaptic() {
        do {
            hapticEngine.stop()
            try hapticAdvancedPlayer?.stop(atTime: 0)
        } catch {
            print("Failed to stopHapric: \(error.localizedDescription)")
        }
    }

    func playHaptic(at inputTexts: String) {
        do {
            stopHaptic()

            hapticAdvancedPlayer?.loopEnabled = false
            hapticAdvancedPlayer?.playbackRate = 1.0

            for i in inputTexts {
                print("#### \(i)")
                try hapticEngine.start()

                if i == "." {
                    let pattern = try makePattern(durations: [0.5], powers: [1.0])
                    hapticAdvancedPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
                    try hapticAdvancedPlayer?.start(atTime: 0)
                    // "." 일 때 0.5초 진동 후 대기
                    Thread.sleep(forTimeInterval: 0.5)
                } else if i == "-" {
                    let pattern = try makePattern(durations: [1.0], powers: [1.0])
                    hapticAdvancedPlayer = try hapticEngine.makeAdvancedPlayer(with: pattern)
                    try hapticAdvancedPlayer?.start(atTime: 0)
                    // "-" 일 때 1.0초 진동 후 대기
                    Thread.sleep(forTimeInterval: 1.0)
                } else {
                    hapticEngine.stop()
                    // 다른 문자일 경우 대기하지 않고 진동을 중지합니다.
                    Thread.sleep(forTimeInterval: 0.5)
                }
                Thread.sleep(forTimeInterval: 0.5)
            }
            stopHaptic()
        } catch {
            print("Failed to playHaptic: \(error)")
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
