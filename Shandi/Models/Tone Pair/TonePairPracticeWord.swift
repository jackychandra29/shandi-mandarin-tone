import CoreGraphics
import Foundation

struct TonePairPracticeWord: Identifiable, Codable {
    let id = UUID()
    let pinyin: String
    let hanzi: String
    let meaning: String
    let tonePair: String
    let question: String
    let answerOptions: [String]
    let correctAnswer: String
    let guidePitch: [CGFloat]

    var wordKey: String {
        "\(hanzi)-\(pinyin)"
    }

    enum CodingKeys: String, CodingKey {
        case pinyin, hanzi, meaning, tonePair, question, answerOptions, correctAnswer, guidePitch
    }
}
