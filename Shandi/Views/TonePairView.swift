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
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)

                Text("Pilih perubahan nada yang ingin kamu latih hari ini.")
                    .font(.system(size: 14, design: .rounded))
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
            header

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
                exitPromptOverlay
            }
        }
    }

    private var sessionCompleteView: some View {
        VStack(spacing: 22) {
            Spacer()

            VStack(spacing: 4) {
                Text("Hebat, [User]!")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.redBrand)

                Text("Sesi selesai!")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.text)
            }

            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.pitchtrack)
                .frame(width: 170, height: 170)
                .overlay(
                    Text("ilustrasi\nmaskot naga")
                        .font(.system(size: 12, design: .rounded))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.text)
                )

            VStack(alignment: .leading, spacing: 16) {
                Text("Ringkasan Sesi")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.text)

                HStack(spacing: 12) {
                    summaryStat(value: "\(session.words.count)", label: "KATA")
                    summaryStat(value: "mā", label: "NADA 1")
                }

                Text("10 kata selesai. Sedikit demi sedikit, nadamu makin stabil")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)
                    .padding(10)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .padding(18)
            .background(Color.yellowBrand)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .padding(.horizontal, 36)

            Button(action: { dismiss() }) {
                Text("Beranda")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.screen)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 12)
                    .background(Color.redBrand)
                    .clipShape(Capsule())
            }

            Spacer()
        }
    }

    private var header: some View {
        ZStack {
            VStack(spacing: 2) {
                Text(session.bodyTitle)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(Color.text)

                Text(session.subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Color.text)
            }

            HStack {
                Spacer()

                Button(action: { session.showsExitPrompt = true }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.screen)
                        .frame(width: 34, height: 34)
                        .background(Color.text)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 24)
        .padding(.bottom, 18)
    }

    private var exitPromptOverlay: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 18) {
                Text("Akhiri latihan?")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.redBrand)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.yellowBrand.opacity(0.35))
                    .frame(width: 130, height: 130)
                    .overlay(
                        Text("ilustrasi\nmaskot naga")
                            .font(.system(size: 12, design: .rounded))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.text)
                    )

                Text("Hari ini kamu sudah latihan [N] kata\nProgresmu sudah tersimpan.")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button(action: session.endSessionEarly) {
                        Text("Akhiri sesi")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.screen)
                            .clipShape(Capsule())
                    }

                    Button(action: { session.showsExitPrompt = false }) {
                        Text("Lanjut")
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.yellowBrand)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 28)
            .frame(maxWidth: 340)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: Color.text.opacity(0.08), radius: 20, y: 8)
        }
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
