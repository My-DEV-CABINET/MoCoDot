//
//  SoundService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Foundation

class SoundService: SoundServiceProtocol {
    var player: AVQueuePlayer = .init()

    /// 변환된 모스코드를 재생하는 메서드
    /// - Parameter message: 변환된 모스부호들
    func generatingMorseCodeSounds(at message: String) {
        var audioItems: [AVPlayerItem] = []

        let longBeepURL = Bundle.main.url(forResource: "beep_long", withExtension: "mp3")
        let shortBeepURL = Bundle.main.url(forResource: "beep_short", withExtension: "mp3")
        let silenceURL = Bundle.main.url(forResource: "silence", withExtension: "mp3")

        guard let longBeepURL = longBeepURL, let shortBeepURL = shortBeepURL, let silenceURL = silenceURL else {
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
            } else {
                let silence = AVPlayerItem(url: silenceURL)
                audioItems.append(silence)
            }
        }

        self.player = AVQueuePlayer(items: audioItems)
        self.player.play()
    }
}
