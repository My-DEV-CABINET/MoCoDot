//
//  Mock.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/29/24.
//

import CoreHaptics
import Foundation

class MockupTapticService: TapticServiceProtocol {
    var hapticEngine: CHHapticEngine?

    var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer?

    init() {
        do {
            let hapticEngine = try CHHapticEngine()
            self.hapticEngine = hapticEngine
        } catch {
            print("Error creating haptic engine: \(error.localizedDescription)")
        }
    }

    func stopHaptic() {
        print("MockupTapticService: stopHaptic called")
        // 여기에 모의 중지 로직을 구현합니다.
    }

    func playHaptic(at inputTexts: String) {
        print("MockupTapticService: playHaptic called with inputTexts: \(inputTexts)")
        // 여기에 모의 재생 로직을 구현합니다.
    }

    func makePattern(durations: [Double], powers: [Float]) throws -> CHHapticPattern {
        print("MockupTapticService: makePattern called with durations: \(durations), powers: \(powers)")
        // 여기에 모의 패턴 생성 로직을 구현합니다.

        let pattern = try CHHapticPattern(events: [], parameters: [])
        return pattern
    }
}
