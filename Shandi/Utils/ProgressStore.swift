import Foundation
import SwiftData

struct ProgressStore {
    let context: ModelContext

    func progress(for category: String) -> PracticeProgress {
        if let existing = fetch(category) {
            return existing
        }

        let created = PracticeProgress(category: category)
        context.insert(created)
        return created
    }

    @discardableResult
    func recordSuccess(category: String, wordID: Int) -> PracticeProgress {
        let progress = self.progress(for: category)

        if !progress.completedWordIDs.contains(wordID) {
            progress.completedWordIDs.append(wordID)
            progress.updatedAt = Date()
            try? context.save()
        }

        return progress
    }

    func completedCount(for category: String) -> Int {
        fetch(category)?.completedCount ?? 0
    }

    private func fetch(_ category: String) -> PracticeProgress? {
        let targetCategory = category
        let descriptor = FetchDescriptor<PracticeProgress>(
            predicate: #Predicate { $0.category == targetCategory }
        )
        return try? context.fetch(descriptor).first
    }
}
