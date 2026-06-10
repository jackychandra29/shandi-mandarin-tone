import SwiftData
import SwiftUI

struct TonePairView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PracticeProgress.category) private var progressRecords:
        [PracticeProgress]

    private let categories: [TonePairPracticeCategory]
    @State private var session: TonePairPracticeSession

    init(categories: [TonePairPracticeCategory]? = nil) {
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
        _session = State(
            initialValue: TonePairPracticeSession(category: safeCategories[0])
        )
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
        .onAppear {
            session = TonePairPracticeSession(
                words: TonePairPracticeMockData.words
            )
        }
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
                .fill(Color.text.opacity(0.28))
                .frame(height: 1)

            VStack(spacing: 0) {
                BigCard {
                    cardContent
                }

                if let actionTitle = session.primaryActionTitle {
                    PrimaryActionButton(
                        title: actionTitle,
                        action: session.advance
                    )
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
            tonePinyin: session.summaryPinyin,
            toneLabel: session.summaryLabel,
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

                Button {
                } label: {
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
            WordDisplay(
                pinyin: word.pinyin,
                hanzi: word.hanzi,
                meaning: word.meaning
            )
            WaveformView(values: word.guidePitch)
            Spacer(minLength: 20)
            ButtonRecord(action: session.advance)
        }
        .padding(.horizontal, 28)
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

    private func introCard(for category: TonePairPracticeCategory) -> some View
    {
        let completedCount = progressCount(for: category)
        let total = category.words.count
        let cardAspectRatio: CGFloat = 160.0 / 200.0

        return Button(action: {
            startPractice(for: category)
        }) {
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
                    .frame(maxWidth: .infinity, minHeight: 50, alignment: .top)

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
            .background(Color.white)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: Sizing.roundedBig,
                    style: .continuous
                )
            )
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
                    .fill(Color.yellowBrand)
                    .frame(width: proxy.size.width * min(max(value, 0), 1))
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
        let total = session.words.count
        session.onAnswerCorrect = { category, wordID in
            let progress = store.recordSuccess(
                category: category,
                wordID: wordID
            )
            progress.total = total
        }
    }

    private func progressCount(for category: TonePairPracticeCategory) -> Int {
        progressRecords
            .first { $0.category == category.progressCategory }?
            .completedCount ?? 0
    }

    private func progressFraction(for category: TonePairPracticeCategory)
        -> Double
    {
        progressRecords
            .first { $0.category == category.progressCategory }?
            .fraction ?? 0
    }
}

#Preview {
    NavigationStack {
        TonePairView()
    }
    .modelContainer(for: PracticeProgress.self, inMemory: true)
}
