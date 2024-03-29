//
//  SoundServiceProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

protocol SoundServiceProtocol {
    var player: AVQueuePlayer { get }

    func pauseMorseCodeSounds()
    func generatingMorseCodeSounds(at message: String) async
}
