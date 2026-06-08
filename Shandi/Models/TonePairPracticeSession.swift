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

    init(words: [TonePairPracticeWord]) {
        self.words = words
    }

    var currentWord: TonePairPracticeWord {
        words[currentWordIndex]
    }

    var bodyTitle: String {
        "Perubahan Nada 3"
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
        selectedAnswer = answer
        step = .answerFeedback
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
