//
//  PronunciationValidator.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 13/06/26.
//

import Foundation

// MARK: - Result Model
struct ValidationResult {
    let syllableCorrect: Bool
    let toneCorrect: Bool
    let feedbackText: String

    var isFullyCorrect: Bool { syllableCorrect && toneCorrect }
}

// MARK: - Validator
struct PronunciationValidator {

    // MARK: - Konfigurasi
    private static let resampleCount = 20  // Potong kontur ke N titik
    private static let toneToleranceRMS: CGFloat = 0.6  // Toleransi RMSE antara kontur user dan target

    // MARK: - Validate
    static func validate(
        recognizedPinyin: String,
        targetWord: SingleTonePracticeWord,
        pitchContour: [CGFloat],
        targetTone: Int
    ) -> ValidationResult {

        // === 1. Syllable Check ===
        // Strip tanda nada dari target pinyin, lalu bandingkan
        let targetPinyinStripped = SpeechAnalyzer.convertToPinyinStripped(targetWord.pinyin)
        let syllableCorrect = !recognizedPinyin.isEmpty && recognizedPinyin == targetPinyinStripped

        // === 2. Tone (Contour) Check ===
        let toneCorrect = checkTone(contour: pitchContour, targetTone: targetTone)

        // === 3. Generate Feedback ===
        let feedback = generateFeedback(
            syllableCorrect: syllableCorrect,
            toneCorrect: toneCorrect,
            targetTone: targetTone,
            recognizedPinyin: recognizedPinyin,
            targetPinyin: targetPinyinStripped
        )

        return ValidationResult(
            syllableCorrect: syllableCorrect,
            toneCorrect: toneCorrect,
            feedbackText: feedback
        )
    }

    // MARK: - Tone Shape Analysis
    private static func checkTone(contour: [CGFloat], targetTone: Int) -> Bool {
        guard contour.count >= 5 else { return false } // Terlalu sedikit data

        let resampled = resample(contour, to: resampleCount)
        let shape = detectShape(resampled)

        switch targetTone {
        case 1: return shape == .flat
        case 2: return shape == .rising
        case 3: return shape == .dippingRising
        case 4: return shape == .falling
        default: return false
        }
    }

    // MARK: - Shape Detection
    private enum ContourShape {
        case flat          // Nada 1: tetap tinggi (5-5)
        case rising        // Nada 2: naik (3-5)
        case dippingRising // Nada 3: turun lalu naik (2-1-4)
        case falling       // Nada 4: turun tajam (5-1)
        case unknown
    }

    private static func detectShape(_ values: [CGFloat]) -> ContourShape {
        guard values.count >= 3 else { return .unknown }

        // Cari titik minimum dalam kontur (untuk deteksi nada 3)
        let minIndex = values.indices.min(by: { values[$0] < values[$1] }) ?? 0
        let minValue = values[minIndex]
        let firstValue = values.first!
        let lastValue = values.last!
        let midValue = values[values.count / 2]

        let totalRange = lastValue - firstValue  // Positif = naik, Negatif = turun
        let absoluteRange = abs(totalRange)

        // --- Flat (Nada 1): range sangat kecil ---
        if absoluteRange < 0.8 {
            return .flat
        }

        // --- Rising (Nada 2): akhir lebih tinggi dari awal, tanpa lembah dalam ---
        if totalRange > 0.8 {
            // Pastikan tidak ada lembah yang dalam (bukan nada 3)
            let dip = firstValue - minValue
            if dip < 0.8 {
                return .rising
            }
        }

        // --- Falling (Nada 4): akhir lebih rendah dari awal ---
        if totalRange < -0.8 {
            return .falling
        }

        // --- Dipping-Rising (Nada 3): ada lembah di tengah, lalu naik ---
        let dip = firstValue - minValue
        let rise = lastValue - minValue
        if dip > 0.5 && rise > 0.5 && minIndex > 1 && minIndex < values.count - 2 {
            return .dippingRising
        }

        return .unknown
    }

    // MARK: - Resample (interpolasi ke N titik)
    private static func resample(_ values: [CGFloat], to count: Int) -> [CGFloat] {
        guard values.count >= 2 else { return values }
        guard values.count != count else { return values }

        var result: [CGFloat] = []
        let ratio = CGFloat(values.count - 1) / CGFloat(count - 1)

        for i in 0..<count {
            let pos = CGFloat(i) * ratio
            let lower = Int(pos)
            let upper = min(lower + 1, values.count - 1)
            let fraction = pos - CGFloat(lower)
            let interpolated = values[lower] * (1 - fraction) + values[upper] * fraction
            result.append(interpolated)
        }

        return result
    }

    // MARK: - Feedback Text Generator
    private static func generateFeedback(
        syllableCorrect: Bool,
        toneCorrect: Bool,
        targetTone: Int,
        recognizedPinyin: String,
        targetPinyin: String
    ) -> String {
        let toneDesc = toneDescription(for: targetTone)

        switch (syllableCorrect, toneCorrect) {
        case (true, true):
            return "Sempurna! Kata dan nadanya benar! 🎉"
        case (true, false):
            return "Katanya benar, tapi nadanya perlu diperbaiki. Coba \(toneDesc)!"
        case (false, true):
            return "Nadanya bagus! Tapi kata yang diucapkan belum tepat. Coba lagi?"
        case (false, false):
            if recognizedPinyin.isEmpty {
                return "Suaramu tidak terdeteksi. Coba ucapkan lebih jelas ke mikrofon."
            }
            return "Kata dan nada belum tepat. Perhatikan pengucapan dan \(toneDesc)."
        }
    }

    private static func toneDescription(for tone: Int) -> String {
        switch tone {
        case 1: return "nada datar dan stabil dari awal sampai akhir"
        case 2: return "nada naik seperti bertanya"
        case 3: return "nada turun dulu, lalu naik kembali"
        case 4: return "nada turun tegas dari awal"
        default: return "nadanya dengan benar"
        }
    }
}
