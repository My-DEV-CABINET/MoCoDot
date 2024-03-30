//
//  TapticServiceProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import Combine
import CoreHaptics
import Foundation

protocol TapticServiceProtocol {
    var hapticEngine: CHHapticEngine? { get }
    var hapticAdvancedPlayer: CHHapticAdvancedPatternPlayer? { get }
    var tapticEndSignPublisher: PassthroughSubject<Bool, Never> { get }

    func stopHaptic()
    func playHaptic(at inputTexts: String)
    func makePattern(durations: [Double], powers: [Float]) throws -> CHHapticPattern
}
