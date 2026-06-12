import Foundation
import SwiftData

enum PracticeCategory {
    static func singleTone(_ tone: Int) -> String {
        "single_tone_\(tone)"
    }

    static func tonePair(_ id: String) -> String {
        "tone_pair_\(id)"
    }
}

@Model
final class PracticeAnswer {
    var questionID: Int = 0
    var category: String = ""
    var isAnswered: Bool = false
    var updatedAt: Date = Date()

    init(questionID: Int, category: String, isAnswered: Bool = true) {
        self.questionID = questionID
        self.category = category
        self.isAnswered = isAnswered
        self.updatedAt = Date()
    }
}
