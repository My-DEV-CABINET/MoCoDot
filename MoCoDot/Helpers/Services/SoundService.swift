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
        print("#### 여기 잡히는가?")

        var items: [AVPlayerItem] = []

        let longBeepURL = Bundle.main.url(forResource: "beep_long", withExtension: "mp3")
        let shortBeepURL = Bundle.main.url(forResource: "beep_short", withExtension: "mp3")
        let silenceURL = Bundle.main.url(forResource: "silence", withExtension: "mp3")

        guard let longBeepURL = longBeepURL, let shortBeepURL = shortBeepURL, let silenceURL = silenceURL else {
            print(SoundServiceError.invalidFileURL.message)
            return
        }

        for character in message.enumerated() {
            print("#### 여기도 잡히는가? \(character)")
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
            print("#### 여기도 잡히는가? \(items)")
            self?.player.removeAllItems()
            self?.player = AVQueuePlayer(items: items)
            self?.player.play()
        }
    }
}
