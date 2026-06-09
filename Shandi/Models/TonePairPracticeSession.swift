import CoreGraphics
import Observation

@Observable
final class TonePairPracticeSession {
    var step: TonePairPracticeStep = .intro
    var selectedAnswer: String?
    var currentWordIndex = 0
    var showsExitPrompt = false
    var userPitch: [CGFloat] = []

    let words: [TonePairPracticeWord]
    let category: String
    let title: String
    let summaryPinyin: String
    let summaryLabel: String

    var onAnswerCorrect: ((_ category: String, _ wordKey: String) -> Void)?

    init(
        words: [TonePairPracticeWord],
        category: String = PracticeCategory.tonePair("nada3"),
        title: String = "Perubahan Nada 3",
        summaryPinyin: String = "ní hǎo",
        summaryLabel: String = "NADA 2 + 3"
    ) {
        self.words = words
        self.category = category
        self.title = title
        self.summaryPinyin = summaryPinyin
        self.summaryLabel = summaryLabel
    }

    convenience init(category: TonePairPracticeCategory) {
        self.init(
            words: category.words,
            category: category.progressCategory,
            title: category.title,
            summaryPinyin: category.summaryPinyin,
            summaryLabel: category.summaryLabel
        )
    }

    var currentWord: TonePairPracticeWord {
        words[currentWordIndex]
    }

    var bodyTitle: String {
        title
    }

    var subtitle: String {
        "Kata ke-\(currentWordIndex + 1) dari sesi latihanmu"
    }

    var primaryActionTitle: String? {
        switch step {
        case .guidedRecording, .answerFeedback:
            "Selanjutnya"
        case .wordComplete:
            currentWordIndex + 1 < words.count ? "Kata berikutnya >" : "Selesai"
        default:
            nil
        }
    }

    func selectAnswer(_ answer: String) {
        guard step == .question else { return }

        selectedAnswer = answer
        step = .answerFeedback

        if answer == currentWord.correctAnswer {
            onAnswerCorrect?(category, currentWord.wordKey)
        }
    }

    func isAnswerHighlighted(_ option: String) -> Bool {
        switch step {
        case .answerFeedback:
            option == currentWord.correctAnswer
        default:
            selectedAnswer == option
        }
    }

    func advance() {
        switch step {
        case .intro:
            step = .guide
        case .guide:
            step = .guidedRecording
        case .guidedRecording:
            step = .question
        case .question:
            step = .answerFeedback
        case .answerFeedback:
            step = .memory
        case .memory:
            step = .wordComplete
        case .wordComplete:
            if currentWordIndex + 1 < words.count {
                currentWordIndex += 1
                selectedAnswer = nil
                userPitch = []
                step = .guide
            } else {
                step = .sessionComplete
            }
        case .sessionComplete:
            break
        }
    }

    func endSessionEarly() {
        showsExitPrompt = false
        step = .sessionComplete
    }
}
