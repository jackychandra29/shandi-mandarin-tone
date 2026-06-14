import SwiftData
import SwiftUI

struct TonePairView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PracticeAnswer.category) private var progressAnswers:
        [PracticeAnswer]

    private let practiceBottomActionHeight: CGFloat = 72

    private let categories: [TonePairPracticeCategory]
    @State private var session: TonePairPracticeSession

    init(categories: [TonePairPracticeCategory]? = nil, previewStep: TonePairPracticeStep? = nil) {
        let loadedCategories =
            categories
            ?? JSONLoader.load(
                fileName: "tone_pair_practice",
                type: [TonePairPracticeCategory].self
            )
            ?? TonePairPracticeMockData.categories
        let safeCategories =
            loadedCategories.isEmpty
            ? TonePairPracticeMockData.categories
            : loadedCategories

        self.categories = safeCategories
        let initialSession = TonePairPracticeSession(category: safeCategories[0])
        if let previewStep {
            initialSession.step = previewStep
        }
        _session = State(initialValue: initialSession)
    }

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
        .toolbar(.hidden, for: .navigationBar)
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
                columns: [
                    GridItem(.flexible(), spacing: 24),
                    GridItem(.flexible(), spacing: 24),
                ],
                spacing: 24
            ) {
                ForEach(categories) { category in
                    introCard(for: category)
                }
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
                .fill(Color.text.opacity(0.35))
                .frame(height: 1)

            GeometryReader { proxy in
                let cardHeight = max(proxy.size.height - practiceBottomActionHeight, 0)

                VStack(spacing: 0) {
                    BigCard {
                        cardContent
                    }
                    .frame(height: cardHeight, alignment: .top)
                    .clipped()

                    bottomActionArea
                        .frame(height: practiceBottomActionHeight, alignment: .top)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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
            tonePinyin: session.summaryPinyin,
            toneLabel: session.summaryLabel,
            onHomeTapped: {
                dismiss()
            }
        )
    }

    @ViewBuilder
    private var bottomActionArea: some View {
        let hasAction = session.primaryActionTitle != nil

        PrimaryActionButton(
            title: session.primaryActionTitle ?? "Selanjutnya",
            verticalPadding: 10,
            action: {
                if hasAction {
                    session.advance()
                }
            }
        )
        .padding(.horizontal, 28)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .opacity(hasAction ? 1 : 0)
        .allowsHitTesting(hasAction)
        .accessibilityHidden(!hasAction)
    }

    @ViewBuilder
    private var cardContent: some View {
        VStack(spacing: 0) {
            HStack {
                Image("TonePairIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Spacer()

                SpeakerButton {
                    TTSService.shared.speakMandarin(word.hanzi)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Group {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var guideContent: some View {
        VStack(spacing: 0) {
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )
            .padding(.top, 18)

            WaveformView(values: word.guidePitch)
                .padding(.top, 28)

            Spacer()

            ButtonRecord(action: session.advance)
                .padding(.bottom, 22)
        }
    }

    private var guidedRecordingContent: some View {
        VStack(spacing: 18) {
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )
            WaveformView(
                values: word.guidePitch,
                comparisonValues: session.userPitch
            )

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
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )

            Rectangle()
                .fill(Color.text.opacity(0.35))
                .frame(height: 1)
                .padding(.top, 26)

            VStack(alignment: .leading, spacing: 24) {
                Text(questionPrompt)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(spacing: 18) {
                    ForEach(word.answerOptions, id: \.self) { option in
                        AnswerOption(
                            title: option,
                            isSelected: session.isAnswerHighlighted(option)
                        ) {
                            session.selectAnswer(option)
                        }
                    }
                }
            }
            .padding(.horizontal, 32)
            .padding(.top, 24)
        }
    }

    private var questionPrompt: String {
        let tones = word.tonePair.components(separatedBy: " + ")
        guard tones.count == 2 else { return word.question }
        return "Jika \(tones[0]) bertemu \(tones[1]), gabungan nadanya berubah menjadi apa?"
    }

    private var memoryContent: some View {
        VStack(spacing: 32) {
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )
            WaveformView(values: [])

            Text(
                "Sekarang giliranmu tanpa dipandu\nIngat nadanya lalu ucapkan!"
            )
            .font(.system(size: 14, design: .rounded))
            .foregroundStyle(Color.text)
            .multilineTextAlignment(.center)

            ButtonRecord(action: session.advance)
        }
        .padding(.horizontal, 28)
    }

    private var wordCompleteContent: some View {
        VStack(spacing: 26) {
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )

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

    private func introCard(for category: TonePairPracticeCategory) -> some View {
        let completedCount = progressCount(for: category)
        let total = category.words.count
        let cardAspectRatio: CGFloat = 160.0 / 200.0

        return Button(action: {
            startPractice(for: category)
        }) {
            ZStack {
                RoundedRectangle(
                    cornerRadius: Sizing.roundedBig,
                    style: .continuous
                )
                .fill(Color.whiteShadow)
                .offset(y: 4)

                VStack(spacing: 8) {
                    Spacer(minLength: 0)

                    Text(cardTitle(for: category))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.orangeBrand)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.78)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 50,
                            alignment: .center
                        )

                    Text(category.subtitle)
                        .font(.system(size: 10.5, design: .rounded))
                        .foregroundStyle(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .minimumScaleFactor(0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(
                            maxWidth: .infinity,
                            minHeight: 50,
                            alignment: .top
                        )

                    progressBar(value: progressFraction(for: category))
                        .frame(height: 8)
                        .padding(.top, 4)

                    Text("\(completedCount)/\(total) latihan kata")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundStyle(Color.text)

                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 26)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .aspectRatio(cardAspectRatio, contentMode: .fit)
                .background(
                    RoundedRectangle(
                        cornerRadius: Sizing.roundedBig,
                        style: .continuous
                    )
                    .fill(Color.white)
                )
            }
        }
        .buttonStyle(.plain)
    }

    private func cardTitle(for category: TonePairPracticeCategory) -> String {
        switch category.id {
        case "nada3":
            "Perubahan\nNada 3"
        case "yi":
            "Perubahan\n\"Yī\""
        case "bu":
            "Perubahan\n\"Bù\""
        case "tetap":
            "Nada\nTetap"
        default:
            category.title
        }
    }

    private func progressBar(value: Double) -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.text.opacity(0.10))

                Capsule()
                    .fill(Color.orangeBrand)
                    .frame(width: proxy.size.width * min(max(value, 0), 1))
            }
            .overlay {
                Capsule()
                    .stroke(Color.orangeBrand, lineWidth: 1)
            }
        }
    }

    private func startPractice(for category: TonePairPracticeCategory) {
        session = TonePairPracticeSession(category: category)
        attachProgressTracking()
        session.advance()
    }

    private func attachProgressTracking() {
        let store = ProgressStore(context: modelContext)
        session.onAnswerCorrect = { category, wordID in
            store.recordSuccess(
                category: category,
                questionID: wordID
            )
        }
    }

    private func progressCount(for category: TonePairPracticeCategory) -> Int {
        let answeredIDs = progressAnswers.filter {
            $0.category == category.progressCategory && $0.isAnswered
        }.map(\.questionID)
        return Set(answeredIDs).count
    }

    private func progressFraction(for category: TonePairPracticeCategory)
        -> Double
    {
        let total = category.words.count
        guard total > 0 else { return 0 }
        return min(Double(progressCount(for: category)) / Double(total), 1)
    }
}

#Preview("Intro") {
    NavigationStack {
        TonePairView()
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}

#Preview("Guide") {
    NavigationStack {
        TonePairView(previewStep: .guide)
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}

#Preview("Question") {
    NavigationStack {
        TonePairView(previewStep: .question)
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}

#Preview("Answer Feedback") {
    NavigationStack {
        TonePairView(previewStep: .answerFeedback)
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}

#Preview("Memory") {
    NavigationStack {
        TonePairView(previewStep: .memory)
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}
