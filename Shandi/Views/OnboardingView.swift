import AVFoundation
import SwiftUI

struct OnboardingView: View {
    @State private var flow: OnboardingFlow

    private let existingName: String?
    let onComplete: (String) -> Void

    private let guidePitch: [CGFloat] = [2.4, 2.4, 2.4, 2.4]
    private let userPitch: [CGFloat] = [1.7, 2.1, 2.7, 3.4]

    init(existingName: String? = nil, onComplete: @escaping (String) -> Void) {
        let trimmedName = existingName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let initialStep: OnboardingFlow.Step = trimmedName.isEmpty ? .welcome : .practiceIntro
        _flow = State(initialValue: OnboardingFlow(name: trimmedName, step: initialStep))
        self.existingName = existingName
        self.onComplete = onComplete
    }

    var body: some View {
        Group {
            switch flow.step {
            case .welcome:
                welcomeView
            case .finish:
                finishView
            default:
                practicePreviewView
                    .overlayPreferenceValue(SpotlightAnchorPreferenceKey.self) { anchors in
                        if let coachmark = flow.coachmark {
                            SpotlightOverlay(
                                coachmark: coachmark,
                                anchors: anchors,
                                onNext: handleCoachmarkAdvance
                            )
                            .transition(.opacity)
                        }
                    }
            }
        }
        .background(Color.screen)
        .animation(.easeOut(duration: 0.28), value: flow.isShowingCoachmark)
        .task(id: flow.step) {
            guard flow.step == .practiceIntro else { return }

            try? await Task.sleep(nanoseconds: 350_000_000)

            guard flow.step == .practiceIntro else { return }
            withAnimation(.easeOut(duration: 0.28)) {
                flow.advance()
            }
        }
        .onChange(of: existingName) { _, newName in
            guard flow.step == .welcome else { return }
            let trimmedName = newName?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !trimmedName.isEmpty else { return }
            flow.name = trimmedName
            flow.step = .practiceIntro
        }
    }

    private var welcomeView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Belajar Bahasa\nMandarin Mulai\ndari Nadanya")
                    .font(Styles.largeTitleShandi)
                    .foregroundStyle(Color.text)

                Text("Dengarkan, ucapkan ulang,\nlalu cek nadamu secara instan")
                    .font(Styles.bodyShandi)
                    .foregroundStyle(Color.text)
            }

            IntroPitchPreview()
                .padding(.top, 40)
                .padding(.horizontal, -30)

            Spacer()

            VStack(alignment: .leading, spacing: 10) {
                Text("Nama kamu?")
                    .font(Styles.bodyShandi)
                    .foregroundStyle(Color.text)

                TextField("Tulis nama kamu", text: $flow.name)
                    .font(Styles.bodyShandi)
                    .foregroundStyle(Color.text)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 14)
                    .background(Color.text.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: Sizing.roundedMedium, style: .continuous))
            }

            PrimaryActionButton(title: "Mulai", action: flow.advance)
                .padding(.top, 32)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 56)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    private var practicePreviewView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Ni Hao, \(flow.displayName) 👋")
                    .font(Styles.title2Shandi)
                    .foregroundStyle(Color.text)

                Text("Yuk coba latihan nada mandarin bersama.")
                    .font(Styles.subheadlineShandi)
                    .foregroundStyle(Color.text)
            }
            .padding(.horizontal, 30)
            .padding(.top, 32)

            BigCard {
                VStack(spacing: 26) {
                    HStack {
                        Spacer()

                        Button(action: {}) {
                            Image(systemName: Icons.speaker)
                                .font(.system(size: 26))
                                .foregroundStyle(Color.text)
                                .frame(width: 48, height: 48)
                        }
                        .spotlightAnchor(.speaker)
                    }

                    WordDisplay(pinyin: "bīng", hanzi: "冰", meaning: "Es")

                    WaveformView(
                        values: guidePitch,
                        comparisonValues: userPitch,
                        title: "Pitch track"
                    )
                    .spotlightAnchor(.waveform)

                    Spacer(minLength: 0)

                    Button(action: {}) {
                        Label("Dengar Nadamu", systemImage: Icons.speaker)
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.text)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(Color.yellowBrand)
                            .clipShape(Capsule())
                    }
                    .spotlightAnchor(.replay)

                    ButtonRecord()
                        .spotlightAnchor(.mic)
                }
            }
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private var finishView: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 8) {
                Text("Mulai latihanmu !")
                    .font(Styles.title2Shandi)
                    .foregroundStyle(Color.text)

                Text("Ayo mulai latihan pertamamu, \(flow.displayName) 👋")
                    .font(Styles.subheadlineShandi)
                    .foregroundStyle(Color.text)
            }

            niHaoDecoration
                .padding(.vertical, 54)

            Text("Nada pertamamu menunggu")
                .font(Styles.headlineShandi)
                .foregroundStyle(Color.text)
                .padding(.bottom, 28)

            PrimaryActionButton(title: "Mulai") {
                onComplete(flow.displayName)
            }

            Spacer()
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var niHaoDecoration: some View {
        ZStack {
            Text("你好")
                .font(.system(size: 112, weight: .bold, design: .rounded))
                .foregroundStyle(Color.redBrand)

            Text("nǐ")
                .offset(x: -80, y: -82)
            Text("hǎo")
                .offset(x: 82, y: -82)
            Text("你")
                .offset(x: -92, y: 66)
            Text("好")
                .offset(x: 92, y: 66)
            Text("nǐ")
                .offset(x: -34, y: 100)
            Text("hǎo")
                .offset(x: 44, y: 100)
        }
        .font(.system(size: 24, weight: .regular, design: .rounded))
        .foregroundStyle(Color.text)
        .frame(maxWidth: .infinity)
        .frame(height: 260)
    }

    private func handleCoachmarkAdvance() {
        guard flow.step == .coachMic else {
            flow.advance()
            return
        }

        AVAudioSession.sharedInstance().requestRecordPermission { _ in
            Task { @MainActor in
                flow.advance()
            }
        }
    }
}

private struct IntroPitchPreview: View {
    var body: some View {
        GeometryReader { geometry in
            let startX: CGFloat = 0
            let endX = geometry.size.width

            ZStack(alignment: .topLeading) {
                Path { path in
                    let y = geometry.size.height * 0.52
                    path.move(to: CGPoint(x: startX, y: y))
                    path.addLine(to: CGPoint(x: endX, y: y))
                }
                .stroke(
                    Color.guidance,
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [10, 8])
                )

                Path { path in
                    path.move(to: CGPoint(x: startX, y: geometry.size.height * 0.74))
                    path.addLine(to: CGPoint(x: endX * 0.42, y: geometry.size.height * 0.56))
                    path.addLine(to: CGPoint(x: endX, y: geometry.size.height * 0.24))
                }
                .stroke(Color.userPitchLine, style: StrokeStyle(lineWidth: 3.5, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(height: 78)
    }
}

#Preview {
    OnboardingView(onComplete: { _ in })
}
