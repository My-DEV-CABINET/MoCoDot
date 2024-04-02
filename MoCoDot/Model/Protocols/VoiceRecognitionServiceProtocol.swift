//
//  VoiceRecognitionServiceProtocol.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/2/24.
//

import Combine
import Foundation
import Speech

protocol VoiceRecognitionServiceProtocol {
    var speechRecognizer: SFSpeechRecognizer { get }
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? { get }
    var recognitionTask: SFSpeechRecognitionTask? { get }
    var audioEngine: AVAudioEngine { get }
    var identifier: String { get }

    var completeEvent: PassthroughSubject<String, Never> { get }

    func startRecording()
    func stopRecording()
    func changeIdentifier(_ identifier: String)
}
