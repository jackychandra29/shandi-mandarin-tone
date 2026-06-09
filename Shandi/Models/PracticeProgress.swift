import Foundation
import SwiftData

enum PracticeCategory {
    static let bankSize = 100

    static func singleTone(_ tone: Int) -> String {
        "single_tone_\(tone)"
    }

    static func tonePair(_ id: String) -> String {
        "tone_pair_\(id)"
    }
}

@Model
final class PracticeProgress {
    @Attribute(.unique) var category: String
    var completedWordIDs: [Int]
    var total: Int
    var updatedAt: Date

    init(category: String, total: Int = PracticeCategory.bankSize) {
        self.category = category
        self.completedWordIDs = []
        self.total = total
        self.updatedAt = Date()
    }

    var completedCount: Int {
        completedWordIDs.count
    }

    var fraction: Double {
        guard total > 0 else { return 0 }
        return min(Double(completedCount) / Double(total), 1)
    }
}
