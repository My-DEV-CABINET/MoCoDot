//
//  VoiceRecognitionService.swift
//  MoCoDot
//
//  Created by 준우의 MacBook 16 on 4/2/24.
//

import Combine
import Foundation
import Speech

final class VoiceRecognitionService: VoiceRecognitionServiceProtocol {
    var speechRecognizer: SFSpeechRecognizer
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var audioEngine: AVAudioEngine
    var identifier: String = LanguageModel.english.identifier

    var completeEvent: PassthroughSubject<String, Never> = .init()

    init() {
        speechRecognizer = .init(locale: Locale(identifier: identifier))!
        recognitionRequest = nil
        recognitionTask = nil
        audioEngine = .init()
    }

    func startRecording() {
        recognitionTask?.cancel()

        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }

        let audioSession = AVAudioSession.sharedInstance()
        speechRecognizer = .init(locale: Locale(identifier: identifier))!

        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation) // 활성화
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        // 인식 요청 설정
        recognitionRequest.shouldReportPartialResults = true

        // 음성 인식 작업 시작
        // recognitionTask 생성
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in

            var isFinal = false

            // 인식 결과가 있으면, TextView 표시
            if result != nil {
                self.completeEvent.send(result?.bestTranscription.formattedString ?? "N/A")
                isFinal = (result?.isFinal)!
            }

            // 오류가 발생하거나 인식이 완료되면 오디오 엔진을 정지, 노드에서 탭을 제거
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        })

        // 오디오 데이터 스트림 처리
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        // 오디오 엔진 준비 및 시작
        audioEngine.prepare()

        // 사용자 안내 메시지 표시
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }

    func stopRecording() {
        recognitionRequest?.endAudio()
        audioEngine.stop()
    }

    func changeIdentifier(_ identifier: String) {
        if identifier == LanguageModel.english.type {
            self.identifier = LanguageModel.english.identifier
        } else {
            self.identifier = LanguageModel.korean.identifier
        }
    }
}
