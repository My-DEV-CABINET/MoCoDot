//
//  SoundService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 3/28/24.
//

import AVFoundation
import Combine
import Foundation

final class SoundService: SoundServiceProtocol {
    var player: AVQueuePlayer = .init()

    /// 모스코드 재생을 중지하는 메서드
    func pauseMorseCodeSounds() {
        player.pause()
    }

    /// 변환된 모스코드를 재생하는 메서드
    /// - Parameter message: 변환된 모스부호들
    func generatingMorseCodeSounds(at message: String) {
        var items: [AVPlayerItem] = []

        let longBeepURL = Bundle.main.url(forResource: "beep_long", withExtension: "mp3")
        let shortBeepURL = Bundle.main.url(forResource: "beep_short", withExtension: "mp3")
        let silenceURL = Bundle.main.url(forResource: "silence", withExtension: "mp3")

        guard let longBeepURL = longBeepURL, let shortBeepURL = shortBeepURL, let silenceURL = silenceURL else {
            print(SoundServiceError.invalidFileURL.message)
            return
        }

        for character in message.enumerated() {
            if character.element == "-" {
                items.append(AVPlayerItem(url: longBeepURL))
            } else if character.element == "." {
                items.append(AVPlayerItem(url: shortBeepURL))
            } else if character.element == " " && character.offset < message.count - 1 {
                items.append(AVPlayerItem(url: silenceURL))
            } else {
                continue
            }
        }

        DispatchQueue.main.async { [weak self] in
            self?.player.removeAllItems()
            self?.player.rate = 0.7
            self?.player = AVQueuePlayer(items: items)
            self?.player.play()
        }
    }
}
