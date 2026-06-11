import Foundation
import SwiftData

struct ProgressStore {
    let context: ModelContext

    @discardableResult
    func recordSuccess(category: String, questionID: Int) -> PracticeAnswer {
        if let existing = fetch(category: category, questionID: questionID) {
            if !existing.isAnswered {
                existing.isAnswered = true
                existing.updatedAt = Date()
            }
            try? context.save()
            return existing
        }

        let created = PracticeAnswer(questionID: questionID, category: category)
        context.insert(created)
        try? context.save()
        return created
    }

    func answeredCount(for category: String) -> Int {
        let targetCategory = category
        let descriptor = FetchDescriptor<PracticeAnswer>(
            predicate: #Predicate {
                $0.category == targetCategory && $0.isAnswered
            }
        )
        let answers = (try? context.fetch(descriptor)) ?? []
        return Set(answers.map(\.questionID)).count
    }

    private func fetch(category: String, questionID: Int) -> PracticeAnswer? {
        let targetCategory = category
        let targetQuestionID = questionID
        let descriptor = FetchDescriptor<PracticeAnswer>(
            predicate: #Predicate {
                $0.category == targetCategory && $0.questionID == targetQuestionID
            }
        )
        return try? context.fetch(descriptor).first
    }
}
