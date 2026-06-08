import SwiftUI

struct TonePairView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var session = TonePairPracticeSession(words: TonePairPracticeMockData.words)

    var body: some View {
        Group {
            switch session.step {
            case .intro:
                introView
            case .sessionComplete:
                sessionCompleteView
            default:
                practiceView
            }
        }
        .background(Color.screen)
        .navigationBarBackButtonHidden()
    }

    private var introView: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color.text)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Mulai dari perubahan nada yang mana?")
                    .font(Styles.largeTitleShandi)
                    .foregroundStyle(Color.text)

                Text("Pilih perubahan nada yang ingin kamu latih hari ini.")
                    .font(Styles.subheadlineShandi)
                    .foregroundStyle(Color.text)
            }

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 20
            ) {
                introCard(
                    title: "Perubahan Nada 3",
                    subtitle: "Latih saat dua Nada 3 bertemu dan nada pertama ikut berubah",
                    progress: "10/100 latihan kata"
                )
                introCard(
                    title: "Perubahan \"Yī\"",
                    subtitle: "Latih perubahan nada \"yī\" sesuai nada setelahnya",
                    progress: "10/100 latihan kata"
                )
                introCard(
                    title: "Perubahan \"Bù\"",
                    subtitle: "Latih perubahan nada \"bù\" sesuai nada setelahnya",
                    progress: "10/100 latihan kata"
                )
                introCard(
                    title: "Nada Tetap",
                    subtitle: "Latih kata yang nadanya tetap sama saat diucapkan",
                    progress: "10/100 latihan kata"
                )
            }

            Spacer()
        }
        .padding(28)
    }

    private var practiceView: some View {
        VStack(spacing: 0) {
            PracticeHeader(
                title: session.bodyTitle,
                subtitle: session.subtitle,
                onExitTap: {
                    session.showsExitPrompt = true
                }
            )

            Rectangle()
                .fill(Color.text.opacity(0.28))
                .frame(height: 1)

            VStack(spacing: 0) {
                BigCard {
                    cardContent
                }

                if let actionTitle = session.primaryActionTitle {
                    PrimaryActionButton(title: actionTitle, action: session.advance)
                        .padding(.horizontal, 28)
                        .padding(.bottom, 28)
                }

            }
        }
        .overlay {
            if session.showsExitPrompt {
                ExitAlertOverlay(
                    wordCount: session.words.count,
                    onExit: {
                        session.endSessionEarly()
                        session.showsExitPrompt = false
                    },
                    onContinue: {
                            session.showsExitPrompt = false
                    }
                )
            }
        }
    }

    private var sessionCompleteView: some View {
        SessionSummaryView(
            wordCount: session.words.count,
            tonePinyin: "mā",
            toneLabel: "NADA 1",
            onHomeTapped: {
                dismiss()
            }
        )
    }

    @ViewBuilder
    private var cardContent: some View {
        VStack {
            HStack {
                Spacer()

                Button {} label: {
                    Image(systemName: Icons.speaker)
                        .font(.system(size: 26))
                        .foregroundStyle(Color.text)
                }
            }

            Spacer(minLength: 12)

            switch session.step {
            case .guide:
                guideContent
            case .guidedRecording:
                guidedRecordingContent
            case .question, .answerFeedback:
                questionContent
            case .memory:
                memoryContent
            case .wordComplete:
                wordCompleteContent
            default:
                EmptyView()
            }
        }
    }

    private var guideContent: some View {
        VStack(spacing: 28) {
            WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
            WaveformView(values: word.guidePitch)
            Spacer(minLength: 20)
            ButtonRecord(action: session.advance)
        }
        .padding(.horizontal, 28)
    }

    private var guidedRecordingContent: some View {
        VStack(spacing: 18) {
            WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
            WaveformView(values: word.guidePitch, comparisonValues: session.userPitch)

            Text("Lebih stabil ! Nadanya naik turun")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Color.orangeBrand)

            Button(action: {}) {
                Label("Dengar Nadamu", systemImage: Icons.speaker)
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.yellowBrand)
                    .clipShape(Capsule())
            }

            Spacer(minLength: 10)
            ButtonRecord()
        }
        .padding(.horizontal, 28)
    }

    private var questionContent: some View {
        VStack(spacing: 0) {
            WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
            Spacer(minLength: 28)

            TonePairQuestion(tonePair: word.tonePair, question: word.question)
            Spacer(minLength: 28)

            VStack(spacing: 12) {
                ForEach(word.answerOptions, id: \.self) { option in
                    AnswerOption(
                        title: option,
                        isSelected: session.isAnswerHighlighted(option)
                    ) {
                        session.selectAnswer(option)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 28)
    }

    private var memoryContent: some View {
        VStack(spacing: 32) {
            WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
            WaveformView(values: [])

            Text("Sekarang giliranmu tanpa dipandu\nIngat nadanya lalu ucapkan!")
                .font(.system(size: 14, design: .rounded))
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.center)

            ButtonRecord(action: session.advance)
        }
        .padding(.horizontal, 28)
    }

    private var wordCompleteContent: some View {
        VStack(spacing: 26) {
            WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
            WaveformView(values: session.userPitch)

            Text("Hebat!\nKamu ingat nadanya")
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.text)
                .multilineTextAlignment(.center)

            ButtonRecord()
        }
        .padding(.horizontal, 28)
    }

    private var word: TonePairPracticeWord {
        session.currentWord
    }

    private func introCard(title: String, subtitle: String, progress: String) -> some View {
        Button(action: session.advance) {
            VStack(spacing: 12) {
                Spacer()

                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.orangeBrand)
                    .multilineTextAlignment(.center)

                Text(subtitle)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.center)

                ProgressView(value: 0.1)
                    .tint(Color.yellowBrand)

                Text(progress)
                    .font(.system(size: 10, design: .rounded))
                    .foregroundStyle(Color.text)

                Spacer()
            }
            .padding(18)
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(Color.pitchtrack)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
    }

    private func summaryStat(value: String, label: String) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(Color.redBrand)

            Text(label)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Color.text)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    NavigationStack {
        TonePairView()
    }
}
