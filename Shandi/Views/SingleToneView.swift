import SwiftData
import SwiftUI

struct SingleToneView: View {
    @StateObject private var viewModel = SingleToneViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PracticeAnswer.category) private var progressAnswers: [PracticeAnswer]
    @State private var availableTones: [Int] = []
    @State private var toneWordCounts: [Int: Int] = [:]

    struct ToneInfo {
        let id: Int; let title: String; let pinyin: String; let desc: String
        static let all: [Int: ToneInfo] = [
            1: ToneInfo(id: 1, title: "Nada 1", pinyin: "mā", desc: "stabil dari awal sampai akhir"),
            2: ToneInfo(id: 2, title: "Nada 2", pinyin: "má", desc: "naik seperti nada bertanya"),
            3: ToneInfo(id: 3, title: "Nada 3", pinyin: "mǎ", desc: "melengkung turun lalu naik"),
            4: ToneInfo(id: 4, title: "Nada 4", pinyin: "mà", desc: "turun tegas dan jelas"),
        ]
    }
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    // MARK: - Body Utama
    var body: some View {
        Group {
            if viewModel.isSessionComplete {
                SessionSummaryView(
                    wordCount: viewModel.wordsCompleted,
                    tonePinyin: getPinyinSymbol(for: viewModel.selectedTone ?? 1),
                    toneLabel: "Nada \(viewModel.selectedTone ?? 1)",
                    onHomeTapped: { dismiss() }
                )
            } else if viewModel.selectedTone == nil {
                introView
            } else {
                practiceView
            }
        }
        .background(Color.screen.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            let store = ProgressStore(context: modelContext)
            let allWords = JSONLoader.load(fileName: "single_tone", type: [SingleTonePracticeWord].self) ?? []
            toneWordCounts = Dictionary(grouping: allWords, by: { $0.tone }).mapValues(\.count)
            viewModel.onWordSuccess = { category, wordID in
                store.recordSuccess(category: category, questionID: wordID)
            }
            
            availableTones = Set(allWords.map(\.tone)).sorted()
        }
        
        .overlay {
            if viewModel.showsExitPrompt {
                ExitAlertOverlay(
                    wordCount: viewModel.wordsCompleted,
                    onExit: {
                        viewModel.showsExitPrompt = false
                        viewModel.isSessionComplete = true
                    },
                    onContinue: {
                        viewModel.showsExitPrompt = false
                    }
                )
                .zIndex(1)
            }
        }
    }

    // MARK: - 1. Intro View (Memakai SingleToneCard milikmu)
    private var introView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // 1. Back Button
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(Color.text)
                }
                .padding(.top, 10)
                
                // 2. Title & Subtitle
                VStack(alignment: .leading, spacing: 10) {
                    Text("Mulai dari nada yang mana?")
                        .font(Styles.largeTitleShandi)
                        .foregroundStyle(Color.text)
                    
                    Text("Pilih nada yang ingin kamu latih hari ini.")
                        .font(Styles.subheadlineShandi)
                        .foregroundStyle(Color.text)
                }
                
                // 3. Grid Cards
                LazyVGrid(columns: columns, spacing: 24) {
                    ForEach(availableTones, id: \.self) { toneId in
                        if let info = ToneInfo.all[toneId] {
                            Button(action: {
                                viewModel.startPractice(for: toneId)
                            }) {
                                SingleToneCard(
                                    title: info.title,
                                    pinyin: info.pinyin,
                                    description: info.desc,
                                    ratio: 160.0 / 200.0,
                                    showSpeaker: false
                                ) {
                                    progressContent(for: toneId)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
    }

    private func progressContent(for tone: Int) -> some View {
        let completedCount = progressCount(for: tone)
        let total = toneWordCounts[tone] ?? 0

        return VStack(spacing: 8) {
            progressBar(value: progressFraction(for: tone))
                .frame(height: 8)

            Text("\(completedCount)/\(total) latihan kata")
                .font(.system(size: 11, design: .rounded))
                .foregroundStyle(Color.text)
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

    private func progressCount(for tone: Int) -> Int {
        let category = PracticeCategory.singleTone(tone)
        let answeredIDs = progressAnswers
            .filter { $0.category == category && $0.isAnswered }
            .map(\.questionID)
        return Set(answeredIDs).count
    }

    private func progressFraction(for tone: Int) -> Double {
        let total = toneWordCounts[tone] ?? 0
        guard total > 0 else { return 0 }
        return min(Double(progressCount(for: tone)) / Double(total), 1)
    }
    
        // MARK: - 2. Practice View
        private var practiceView: some View {
            VStack(spacing: 0) {
                PracticeHeader(
                    title: "Nada \(viewModel.selectedTone ?? 1)",
                    subtitle: "Kata ke-\(viewModel.wordsCompleted + 1) dari sesi latihanmu",
                    onExitTap: {
                        withAnimation {
                            viewModel.showsExitPrompt = true
                        }
                    }
                )

                Rectangle()
                    .fill(Color.text.opacity(0.35))
                    .frame(height: 1)

                BigCard {
                    cardContent
                }

                bottomActionArea
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .overlay {
                if viewModel.showsExitPrompt {
                    ExitAlertOverlay(
                        wordCount: viewModel.wordsCompleted,
                        onExit: {
                            withAnimation {
                                viewModel.showsExitPrompt = false
                                viewModel.isSessionComplete = true
                            }
                        },
                        onContinue: {
                            withAnimation {
                                viewModel.showsExitPrompt = false
                            }
                        }
                    )
                    .zIndex(1)
                }
            }
        }

        @ViewBuilder
        private var bottomActionArea: some View {
            if viewModel.currentState == .success {
                PrimaryActionButton(title: "Selanjutnya", action: viewModel.nextWord)
                    .padding(.horizontal, 28)
                    .padding(.top, 12)
                    .padding(.bottom, 28)
            }
        }
        
        // MARK: - Sub-komponen Card Content
        @ViewBuilder
        private var cardContent: some View {
            VStack {
                HStack {
                    Spacer()

                    SpeakerButton {
                        if let word = viewModel.currentWord {
                            TTSService.shared.speakMandarin(word.hanzi)
                        }
                    }
                }
                .padding(.horizontal,12)
                
                Spacer(minLength: 12)
                
                if let word = viewModel.currentWord {
                    switch viewModel.currentState {
                    case .idle, .recording:
                        idleContent(word: word)
                    case .failed:
                        feedbackContent(word: word, isSuccess: false)
                    case .success:
                        feedbackContent(word: word, isSuccess: true)
                    case .analyzing:
                        VStack {
                            Spacer()
                            ProgressView("Menganalisis...")
                            Spacer()
                        }
                    }
                } else {
                    ProgressView("Menyiapkan...")
                }
            }
        }
        
        // 1. Tampilan saat Awal / Sedang Merekam
        private func idleContent(word: SingleTonePracticeWord) -> some View {
            VStack(spacing: 28) {
                WordDisplay(
                    pinyin: word.pinyin,
                    hanzi: word.hanzi,
                    meaning: word.meaning,
                    pinyinColor: .redBrand
                )
                
                WaveformView(
                    segments: [getTargetChaoValues(for: viewModel.selectedTone ?? 1)],
                    userSegments: viewModel.pitchValues.isEmpty ? nil : [viewModel.pitchValues]
                )
                .padding(.horizontal, 28)
                
                Spacer(minLength: 30)
                
                ButtonRecord {
                    viewModel.toggleRecording()
                }
                Spacer(minLength: 5)
            }
        }
        
        // 2. Tampilan saat ada Feedback
        private func feedbackContent(word: SingleTonePracticeWord, isSuccess: Bool) -> some View {
            let result = viewModel.lastValidationResult
            let feedbackText = result?.feedbackText ?? (isSuccess ? "Mantap! Semuanya benar!" : "Belum tepat, coba lagi!")
            let feedbackColor: Color = {
                guard let r = result else { return isSuccess ? .green : Color.redBrand }
                if r.isFullyCorrect { return .green }
                if r.syllableCorrect { return Color.orangeBrand }  // nada salah, kata benar
                if r.toneCorrect { return Color.yellowBrand }       // kata salah, nada benar
                return Color.redBrand                               // keduanya salah
            }()
            
            return VStack(spacing: 18) {
                WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
                
                WaveformView(
                    segments: [getTargetChaoValues(for: viewModel.selectedTone ?? 1)],
                    userSegments: viewModel.pitchValues.isEmpty ? nil : [viewModel.pitchValues]
                )
                .padding(.horizontal, 28)
                
                // Feedback dari PronunciationValidator
                Text(feedbackText)
                    .font(Styles.headlineShandi)
                    .foregroundStyle(feedbackColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                
                // Tombol Dengar Nadamu
                Button(action: {}) {
                    Label("Dengar Nadamu", systemImage: "speaker.wave.2.fill")
                        .font(Styles.captionShandi)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.text)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.yellowBrand)
                        .clipShape(Capsule())
                }
                
                Spacer(minLength: 10)
                
                if !isSuccess {
                    ButtonRecord {
                        viewModel.toggleRecording()
                    }
                } else {
                    Spacer(minLength: 60)
                }
                Spacer(minLength: 5)
            }
        }
    
    // MARK: - Utility Functions
    private func getTargetChaoValues(for tone: Int) -> [CGFloat] {
        switch tone {
        case 1: return [5.0, 5.0]
        case 2: return [3.0, 5.0]
        case 3: return [2.0, 1.0, 4.0]
        case 4: return [5.0, 1.0]
        default: return [3.0, 3.0]
        }
    }
    
    private func getPinyinSymbol(for tone: Int) -> String {
        switch tone {
        case 1: return "mā"
        case 2: return "má"
        case 3: return "mǎ"
        case 4: return "mà"
        default: return "-"
        }
    }
}

#Preview {
    NavigationStack {
        SingleToneView()
    }
    .modelContainer(for: [PracticeAnswer.self, UserProfile.self], inMemory: true)
}
