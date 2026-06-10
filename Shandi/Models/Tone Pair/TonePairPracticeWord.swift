import CoreGraphics
import Foundation

struct TonePairPracticeWord: Identifiable, Codable {
    let id: Int
    let pinyin: String
    let hanzi: String
    let meaning: String
    let tonePair: String
    let question: String
    let answerOptions: [String]
    let correctAnswer: String
    let guidePitch: [CGFloat]
}
