import SwiftData
import SwiftUI

struct SingleToneView: View {
    @StateObject private var viewModel = SingleToneViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let tones = [
        (id: 1, title: "Nada 1", pinyin: "mā", desc: "stabil dari awal sampai akhir", progress: 10.0),
        (id: 2, title: "Nada 2", pinyin: "má", desc: "naik seperti nada bertanya", progress: 25.0),
        (id: 3, title: "Nada 3", pinyin: "mǎ", desc: "melengkung turun lalu naik", progress: 40.0),
        (id: 4, title: "Nada 4", pinyin: "mà", desc: "turun tegas\ndan jelas", progress: 55.0)
    ]
    
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
        .onAppear {
            let store = ProgressStore(context: modelContext)
            viewModel.onWordSuccess = { category, wordKey in
                store.recordSuccess(category: category, wordKey: wordKey)
            }
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
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(tones, id: \.id) { tone in
                        Button(action: {
                            viewModel.startPractice(for: tone.id)
                        }) {
                            SingleToneCard(
                                title: tone.title,
                                pinyin: tone.pinyin,
                                description: tone.desc,
                                ratio: 160.0 / 200.0,
                                showSpeaker: false
                            ) {
                                // Bottom Content: Progress Bar
                                VStack(spacing: 10) {
                                    GeometryReader { geoProgress in
                                        ZStack(alignment: .leading) {
                                            // Background Track
                                            Capsule()
                                                .fill(Color.screen)
                                            // Progress Indicator
                                            Capsule()
                                                .fill(Color.yellowBrand)
                                                .frame(width: geoProgress.size.width * (tone.progress / 100.0))
                                        }
                                    }
                                    .frame(height: 8)
                                    .padding(.horizontal, 24)
                                    
                                    // Teks Progress
                                    Text("\(Int(tone.progress))/100 latihan kata")
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(red: 0.35, green: 0.2, blue: 0.05))
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.top, 10)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 100)
        }
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
                    .fill(Color.text.opacity(0.28))
                    .frame(height: 1)
                
                VStack(spacing: 0) {
                    BigCard {
                        cardContent
                    }
                    
                    if viewModel.currentState == .success {
                        PrimaryActionButton(title: "Selanjutnya", action: viewModel.nextWord)
                            .padding(.horizontal, 28)
                            .padding(.bottom, 28)
                    } else {
                        Spacer().frame(height: 70)
                    }
                }
            }
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
        
        // MARK: - Sub-komponen Card Content
        @ViewBuilder
        private var cardContent: some View {
            VStack {
                HStack {
                    Spacer()
                    Button {} label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 26))
                            .foregroundStyle(Color.text)
                    }
                }
                
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
                WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
                
                WaveformView(
                    values: getTargetChaoValues(for: viewModel.selectedTone ?? 1),
                    comparisonValues: nil,
                    title: "Jejak nada"
                )
                
                Spacer(minLength: 30)
                
                ButtonRecord {
                    viewModel.toggleRecording()
                }
                Spacer(minLength: 5)
            }
        }
        
        // 2. Tampilan saat ada Feedback
        private func feedbackContent(word: SingleTonePracticeWord, isSuccess: Bool) -> some View {
            VStack(spacing: 18) {
                WordDisplay(pinyin: word.pinyin, hanzi: word.hanzi, meaning: word.meaning)
                
                WaveformView(
                    values: getTargetChaoValues(for: viewModel.selectedTone ?? 1),
                    comparisonValues: nil,
                    title: "Jejak nada"
                )
                
                // Feedback
                Text(isSuccess ? "Mantap! Nadanya rapi dan stabil" : "Lebih stabil! Nadanya naik turun")
                    .font(Styles.headlineShandi)
                    .foregroundStyle(Color.redBrand)
                
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
}
