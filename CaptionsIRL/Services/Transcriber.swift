//
//  Transcriber.swift
//  CaptionsIRL
//
//  Created by Sidney Sadel on 2/8/24.
//

import Foundation
import Speech
import Combine

@Observable
final class Transcriber {
    enum TranscriberError: Error {
        case notAuthorized
        case failedToConfigRequest
        case alreadyRecording
    }
    
    private(set) var isRecording: Bool = false
    private(set) var transcribedText: String = ""
    private(set) var segments: [SFTranscriptionSegment] = []
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer: SFSpeechRecognizer! = {
        let recognizer = SFSpeechRecognizer() ?? SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        recognizer?.defaultTaskHint = .dictation
        return recognizer
    }()
    private let audioEngine = AVAudioEngine()
    
    func start() throws {
        guard !isRecording else {
            stop()
            throw Self.TranscriberError.alreadyRecording
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        try self.setupNewTask()
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        isRecording = true
    }
    
    func setupNewTask() throws {
        guard let recognitionRequest = self.recognitionRequest else {
            throw Self.TranscriberError.failedToConfigRequest
        }
        recognitionTask?.cancel()
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            self?.transcribedText = result?.bestTranscription.formattedString ?? ""
            self?.segments = result?.bestTranscription.segments ?? []
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//            self?.transcribedText.removeAll()
//            self?.segments.removeAll()
//        }
    }
    
    func stop() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        isRecording = false
    }
}
