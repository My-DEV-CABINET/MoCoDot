//
//  SoundService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

enum SoundServiceError: Error {
    case invalidFileURL

    var message: String {
        switch self {
        case .invalidFileURL:
            return "Beep file URLs are not available"
        }
    }
}

class SoundService: SoundServiceProtocol {
    var player: AVQueuePlayer = .init()

    func generatingMorseCodeSounds(at message: String) {
        var audioItems: [AVPlayerItem] = []

        let longBeepURL = Bundle.main.url(forResource: "beep_long", withExtension: "mp3")
        let shortBeepURL = Bundle.main.url(forResource: "beep_short", withExtension: "mp3")

        guard let longBeepURL = longBeepURL, let shortBeepURL = shortBeepURL else {
            print(SoundServiceError.invalidFileURL.message)
            return
        }

        for character in message {
            if character == "-" {
                let longBeep = AVPlayerItem(url: longBeepURL)
                audioItems.append(longBeep)
            } else if character == "." {
                let shortBeep = AVPlayerItem(url: shortBeepURL)
                audioItems.append(shortBeep)
            }
        }

        self.player = AVQueuePlayer(items: audioItems)
        self.player.play()
    }
}
