import Foundation
import Observation

struct CoachmarkContent {
    let target: SpotlightTarget
    let title: String
    let message: String
}

@Observable
final class OnboardingFlow {
    enum Step {
        case welcome
        case practiceIntro
        case coachSpeaker
        case coachMic
        case coachWaveform
        case coachReplay
        case finish
    }

    var name = ""
    var step: Step = .welcome

    var displayName: String {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedName.isEmpty ? "User" : trimmedName
    }

    var isShowingCoachmark: Bool {
        coachmark != nil
    }

    var coachmark: CoachmarkContent? {
        switch step {
        case .coachSpeaker:
            CoachmarkContent(
                target: .speaker,
                title: "Latih telingamu dulu!",
                message: "Dengar nadanya, pahami naik-turunnya, lalu coba ucapkan ulang"
            )
        case .coachMic:
            CoachmarkContent(
                target: .mic,
                title: "Sekarang giliranmu",
                message: "Tirukan nadanya, lalu cek hasil nada-mu secara langsung"
            )
        case .coachWaveform:
            CoachmarkContent(
                target: .waveform,
                title: "Cek nadamu langsung",
                message: "Perhatikan naik-turun nadamu saat kamu ucapkan"
            )
        case .coachReplay:
            CoachmarkContent(
                target: .replay,
                title: "Dengar nadamu",
                message: "Dengar ulang nada-mu dan lihat bagian nada yang masih perlu diperbaiki"
            )
        default:
            nil
        }
    }

    func advance() {
        switch step {
        case .welcome:
            step = .practiceIntro
        case .practiceIntro:
            step = .coachSpeaker
        case .coachSpeaker:
            step = .coachMic
        case .coachMic:
            step = .coachWaveform
        case .coachWaveform:
            step = .coachReplay
        case .coachReplay:
            step = .finish
        case .finish:
            break
        }
    }
}
