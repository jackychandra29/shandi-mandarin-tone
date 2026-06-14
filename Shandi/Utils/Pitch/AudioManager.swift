//
//  AudioManager.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 13/06/26.
//

import Foundation
import AVFoundation
import Combine

class AudioManager: ObservableObject {

    // MARK: - Dependencies
    private let pitchAnalyzer = PitchAnalyzer()
    private let speechAnalyzer = SpeechAnalyzer()

    // MARK: - Published State
    @Published var pitchValues: [CGFloat] = []
    @Published var isRecording: Bool = false

    // MARK: - Private
    private var audioEngine: AVAudioEngine?
    private var inputFormat: AVAudioFormat?

    // MARK: - Reset
    func reset() {
        pitchValues = []
        pitchAnalyzer.reset()
    }

    // MARK: - Start Recording
    func startRecording(targetTone: Int) {
        reset()

        // Set target start pitch ke PitchAnalyzer berdasarkan nada tujuan
        pitchAnalyzer.targetStartPitch = startPitch(for: targetTone)

        // 1. Konfigurasi AVAudioSession
        configureAudioSession()

        // 2. Bangun engine
        let engine = AVAudioEngine()
        self.audioEngine = engine
        let inputNode = engine.inputNode

        // 3. Aktifkan Voice Processing (noise suppression hardware-level)
        do {
            try inputNode.setVoiceProcessingEnabled(true)
        } catch {
            print("AudioManager: Voice processing tidak tersedia: \(error)")
        }

        let format = inputNode.outputFormat(forBus: 0)
        self.inputFormat = format

        // 4. Siapkan SpeechAnalyzer
        speechAnalyzer.startListening()

        // 5. Satu tap, dua jalur
        inputNode.installTap(onBus: 0, bufferSize: 2048, format: format) { [weak self] buffer, time in
            guard let self = self else { return }

            // === JALUR 1: Pitch Analysis ===
            let channelCount = Int(buffer.format.channelCount)
            guard channelCount > 0,
                  let channelData = buffer.floatChannelData else { return }

            let frameLength = Int(buffer.frameLength)
            let samples = Array(UnsafeBufferPointer(start: channelData[0], count: frameLength))
            let sampleRate = Float(buffer.format.sampleRate)

            if let pitchLevel = self.pitchAnalyzer.analyze(buffer: samples, sampleRate: sampleRate) {
                DispatchQueue.main.async {
                    self.pitchValues.append(pitchLevel)
                }
            }

            // === JALUR 2: Speech Recognition ===
            self.speechAnalyzer.appendBuffer(buffer)
        }

        // 6. Jalankan engine
        do {
            try engine.start()
            DispatchQueue.main.async { self.isRecording = true }
        } catch {
            print("AudioManager: Gagal start engine: \(error)")
        }
    }

    // MARK: - Stop Recording & Validate
    func stopRecording(targetWord: SingleTonePracticeWord, targetTone: Int) -> ValidationResult {
        // Stop all
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine?.stop()
        audioEngine = nil
        speechAnalyzer.stopListening()

        DispatchQueue.main.async { self.isRecording = false }

        // Result
        let recognizedPinyin = speechAnalyzer.recognizedPinyin
        let capturedPitch = pitchValues

        // Validation
        return PronunciationValidator.validate(
            recognizedPinyin: recognizedPinyin,
            targetWord: targetWord,
            pitchContour: capturedPitch,
            targetTone: targetTone
        )
    }

    // MARK: - Private Helpers

    private func configureAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth])
            try session.setActive(true)
        } catch {
            print("AudioManager: Gagal set audio session: \(error)")
        }
    }

    private func startPitch(for tone: Int) -> CGFloat {
        switch tone {
        case 1: return 5.0
        case 2: return 3.0
        case 3: return 2.0
        case 4: return 5.0
        default: return 3.0
        }
    }
}
