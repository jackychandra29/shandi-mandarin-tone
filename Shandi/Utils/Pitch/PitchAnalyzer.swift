//
//  PitchAnalyzer.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 13/06/26.
//

import Foundation
import Accelerate

class PitchAnalyzer {

    // MARK: - Konfigurasi
    // Rentang frekuensi suara manusia yang valid
    private let minFrequency: Float = 80.0   // Hz (bawah suara pria dewasa)
    private let maxFrequency: Float = 350.0  // Hz (atas suara wanita/anak-anak)

    // Moving Average: buffer dari N deteksi terakhir untuk smoothing alami
    private let smoothingWindowSize: Int = 5
    private var recentFrequencies: [Float] = []

    // Anchor System: titik awal disesuaikan dengan target nada Mandarin
    private var initialFrequency: Float? = nil
    var targetStartPitch: CGFloat = 3.0

    // MARK: - Reset
    func reset() {
        initialFrequency = nil
        recentFrequencies = []
    }

    // MARK: - Analisis Utama
    /// Menerima buffer audio dan mengembalikan nilai pitch skala 1-5, atau nil jika tidak ada suara valid.
    func analyze(buffer: [Float], sampleRate: Float) -> CGFloat? {
        guard !buffer.isEmpty else { return nil }

        // Step 1: RMS check — filter noise (suara latar yang pelan)
        var rms: Float = 0
        vDSP_rmsqv(buffer, 1, &rms, vDSP_Length(buffer.count))
        let dB = 20 * log10(rms)
        guard dB > -30.0 else { return nil } // Noise gate -30 dB

        // Step 2: Autocorrelation untuk deteksi frekuensi dasar
        guard let frequency = autocorrelationPitch(buffer: buffer, sampleRate: sampleRate) else {
            return nil
        }

        // Step 3: Moving Average smoothing
        recentFrequencies.append(frequency)
        if recentFrequencies.count > smoothingWindowSize {
            recentFrequencies.removeFirst()
        }
        let smoothedFrequency = recentFrequencies.reduce(0, +) / Float(recentFrequencies.count)

        // Step 4: Konversi ke skala 1-5 berbasis anchor
        return convertToScale(frequency: smoothedFrequency)
    }

    // MARK: - Autocorrelation F0 Detection
    private func autocorrelationPitch(buffer: [Float], sampleRate: Float) -> Float? {
        let n = buffer.count

        // Hitung lag minimum dan maksimum berdasarkan rentang frekuensi yang valid
        let minLag = Int(sampleRate / maxFrequency) // lag kecil = frekuensi tinggi
        let maxLag = Int(sampleRate / minFrequency) // lag besar = frekuensi rendah

        guard minLag < maxLag, maxLag < n else { return nil }

        // Hitung autocorrelation menggunakan vDSP_conv
        // r[lag] = sum(x[i] * x[i+lag]) untuk setiap lag
        var acf = [Float](repeating: 0, count: maxLag + 1)
        for lag in minLag...maxLag {
            var sum: Float = 0
            // Gunakan vDSP dot product untuk setiap lag
            let count = n - lag
            guard count > 0 else { continue }
            vDSP_dotpr(
                buffer, 1,
                Array(buffer[lag...]), 1,
                &sum,
                vDSP_Length(count)
            )
            acf[lag] = sum
        }

        // Cari peak tertinggi dalam rentang lag yang valid
        var bestLag = minLag
        var bestValue: Float = acf[minLag]
        for lag in (minLag + 1)...maxLag {
            if acf[lag] > bestValue {
                bestValue = acf[lag]
                bestLag = lag
            }
        }

        // Validasi: peak harus positif (ada nada periodik yang jelas)
        guard bestValue > 0 else { return nil }

        // Konversi lag ke frekuensi
        let frequency = sampleRate / Float(bestLag)
        guard frequency >= minFrequency, frequency <= maxFrequency else { return nil }

        return frequency
    }

    // MARK: - Konversi ke Skala 1-5
    private func convertToScale(frequency: Float) -> CGFloat {
        if initialFrequency == nil {
            // Frame pertama yang valid: jadikan jangkar (anchor)
            initialFrequency = frequency
            return targetStartPitch
        }

        guard let anchor = initialFrequency else { return targetStartPitch }

        // Hitung perbedaan dalam semitone: 12 * log2(f / f0)
        let semitones = 12.0 * log2(frequency / anchor)

        // Sensitivitas: 1.5 semitone = 1 unit pada skala 1-5
        // Angka ini bisa disesuaikan. Mandarin tone range umumnya ~8-10 semitone
        let pitchDiff = CGFloat(semitones / 1.5)
        let pitchLevel = targetStartPitch + pitchDiff

        return min(max(pitchLevel, 1.0), 5.0)
    }
}
