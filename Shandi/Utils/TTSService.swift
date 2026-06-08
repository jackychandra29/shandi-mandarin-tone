//
//  TTSservice.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import AVFoundation

final class TTSService {
    static let shared = TTSService()
    
    private let synthesizer = AVSpeechSynthesizer()
    
    private init() {}
    
    /// Fungsi modular untuk membaca teks Mandarin
    /// - Parameters:
    ///   - text: Teks Hanzi atau Pinyin yang ingin dibaca
    ///   - rate: Kecepatan bicara (default 0.4 agar pas untuk latihan/pembelajaran)
    func speakMandarin(_ text: String, rate: Float = 0.4) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = rate
        
        synthesizer.speak(utterance)
    }
}
