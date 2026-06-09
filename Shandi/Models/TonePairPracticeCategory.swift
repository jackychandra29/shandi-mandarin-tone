import Foundation

struct TonePairPracticeCategory: Identifiable, Codable {
    let id: String
    let title: String
    let subtitle: String
    let summaryPinyin: String
    let summaryLabel: String
    let words: [TonePairPracticeWord]

    var progressCategory: String {
        PracticeCategory.tonePair(id)
    }
}
