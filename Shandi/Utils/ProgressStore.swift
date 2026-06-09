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
    func recordSuccess(category: String, wordKey: String) -> PracticeProgress {
        let progress = self.progress(for: category)

        if !progress.completedWordKeys.contains(wordKey) {
            progress.completedWordKeys.append(wordKey)
            progress.updatedAt = Date()
            try? context.save()
        }

        return progress
    }

    func completedCount(for category: String) -> Int {
        fetch(category)?.completedCount ?? 0
    }

    private func fetch(_ category: String) -> PracticeProgress? {
        let descriptor = FetchDescriptor<PracticeProgress>(
            predicate: #Predicate { $0.category == category }
        )
        return try? context.fetch(descriptor).first
    }
}
