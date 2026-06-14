//
//  SpeechAnalyzer.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 13/06/26.
//

import Foundation
import Speech

class SpeechAnalyzer {

    // MARK: - Properties
    private var recognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    /// Suku kata terakhir yang dikenali (Pinyin tanpa tanda nada), misal "ma", "ni", "hao"
    private(set) var recognizedPinyin: String = ""

    /// Teks Hanzi mentah yang terakhir dikenali, misal "妈", "你好"
    private(set) var recognizedHanzi: String = ""

    // MARK: - Init
    init() {
        // Set locale ke Mandarin Simplified (zh-CN)
        recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    }

    // MARK: - Permission
    static func requestPermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }

    // MARK: - Start
    /// Siapkan recognition request. Buffer audio akan di-append dari AudioManager.
    func startListening() {
        recognizedPinyin = ""
        recognizedHanzi = ""

        guard let recognizer = recognizer, recognizer.isAvailable else {
            print("SpeechAnalyzer: Speech recognizer tidak tersedia (perlu koneksi internet pertama kali).")
            return
        }

        recognitionTask?.cancel()
        recognitionTask = nil

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let request = recognitionRequest else { return }

        request.shouldReportPartialResults = true

        // Opsional: jika iOS 16+, gunakan on-device recognition
        if #available(iOS 16, *) {
            request.requiresOnDeviceRecognition = false // false = boleh pakai server Apple
        }

        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                let hanzi = result.bestTranscription.formattedString
                self.recognizedHanzi = hanzi
                // Konversi Hanzi ke Pinyin lalu strip tanda nada
                self.recognizedPinyin = Self.convertToPinyinStripped(hanzi)
            }

            if let error = error {
                // SFSpeechRecognizer sering mengembalikan error ketika di-stop manual — itu normal
                let nsError = error as NSError
                if nsError.domain == "kAFAssistantErrorDomain" || nsError.code == 1110 {
                    return // Error normal saat stop, abaikan
                }
                print("SpeechAnalyzer error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Feed Audio Buffer
    /// Dipanggil oleh AudioManager setiap kali ada buffer baru dari mikrofon.
    func appendBuffer(_ buffer: AVAudioPCMBuffer) {
        recognitionRequest?.append(buffer)
    }

    // MARK: - Stop
    func stopListening() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionRequest = nil
        recognitionTask = nil
    }

    // MARK: - Konversi Hanzi → Pinyin tanpa nada
    /// Contoh: "妈" → "ma", "你好" → "nihao"
    static func convertToPinyinStripped(_ hanzi: String) -> String {
        // Step 1: Hanzi → Latin dengan tanda nada (misal: "妈" → "mā")
        // Menggunakan StringTransform.toLatin bawaan Swift/Foundation
        let withTones = hanzi.applyingTransform(StringTransform.toLatin, reverse: false) ?? hanzi

        // Step 2: Strip tanda nada (misal: "mā" → "ma")
        let stripped = withTones.applyingTransform(StringTransform.stripDiacritics, reverse: false) ?? withTones

        // Step 3: Lowercase dan hapus spasi
        return stripped.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
