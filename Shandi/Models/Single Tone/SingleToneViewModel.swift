//
//  SingleToneViewModel.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import SwiftUI
import Combine

enum PracticeState {
    case idle
    case recording
    case analyzing
    case success
    case failed
}

@MainActor
class SingleToneViewModel: ObservableObject {
    @Published var currentState: PracticeState = .idle
    @Published var currentWord: SingleTonePracticeWord?
    @Published var showsExitPrompt: Bool = false
    @Published var isSessionComplete: Bool = false
    
    @Published var wordsCompleted: Int = 0
    private var wordQueue: [SingleTonePracticeWord] = []
    
    @Published var selectedTone: Int? = nil
    
    var onWordSuccess: ((_ category: String, _ wordID: Int) -> Void)?

    // MARK: - Audio Pipeline
    let audioManager = AudioManager()
    @Published var pitchValues: [CGFloat] = []
    @Published var lastValidationResult: ValidationResult? = nil

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Forward pitch values dari AudioManager ke ViewModel agar View bisa observe
        audioManager.$pitchValues
            .receive(on: RunLoop.main)
            .sink { [weak self] values in
                self?.pitchValues = values
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Navigation
    func startPractice(for tone: Int) {
        self.selectedTone = tone
        self.pitchValues = []
        self.lastValidationResult = nil
        self.loadWords(for: tone)
    }

    func resetToIntro() {
        withAnimation {
            self.selectedTone = nil
            self.currentState = .idle
            self.isSessionComplete = false
            self.pitchValues = []
            self.lastValidationResult = nil
        }
    }
    
    // MARK: - Logic Load Data
    func loadWords(for tone: Int) {
        let allWords = JSONLoader.load(
            fileName: "single_tone",
            type: [SingleTonePracticeWord].self
        ) ?? []
        
        print("DEBUG: Jumlah kata total di file JSON: \(allWords.count)")
        
        self.wordQueue = allWords.filter { $0.tone == tone }.shuffled()
        
        print("DEBUG: Jumlah kata untuk Nada \(tone): \(self.wordQueue.count)")
        
        if self.wordQueue.isEmpty {
            print("DEBUG: PERINGATAN! Kata kosong, sesi otomatis selesai.")
        }
        
        self.wordsCompleted = 0
        nextWord()
    }
    
    func nextWord() {
        guard !wordQueue.isEmpty else {
            withAnimation { isSessionComplete = true }
            return
        }
        currentWord = wordQueue.removeFirst()
        currentState = .idle
        pitchValues = []
        lastValidationResult = nil
        audioManager.reset()
    }
    

    // MARK: - Recording
    func toggleRecording() {
        if currentState == .recording {
            stopRecordingAndValidate()
        } else {
            startRecording()
        }
    }

    private func startRecording() {
        currentState = .recording
        pitchValues = []
        lastValidationResult = nil

        #if targetEnvironment(simulator)
        // ── SIMULATOR: inject fake pitch and auto-stop after 1.5s ──
        simulateMicInput()
        #else
        audioManager.startRecording(targetTone: selectedTone ?? 1)
        #endif
    }

    private func stopRecordingAndValidate() {
        currentState = .analyzing

        guard let word = currentWord, let tone = selectedTone else {
            currentState = .failed
            return
        }

        #if targetEnvironment(simulator)
        // ── SIMULATOR: always return success so UI flow can be tested ──
        let fakeResult = ValidationResult(
            syllableCorrect: true,
            toneCorrect: true,
            feedbackText: "Simulator: Sempurna! 🎉"
        )
        self.lastValidationResult = fakeResult
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentState = .success
            self.wordsCompleted += 1
            self.onWordSuccess?(PracticeCategory.singleTone(tone), word.id)
        }
        #else
        let result = audioManager.stopRecording(targetWord: word, targetTone: tone)
        self.lastValidationResult = result

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if result.isFullyCorrect {
                self.currentState = .success
                self.wordsCompleted += 1
                self.onWordSuccess?(
                    PracticeCategory.singleTone(tone),
                    word.id
                )
            } else {
                self.currentState = .failed
            }
        }
        #endif
    }

    #if targetEnvironment(simulator)
    /// Feeds fake pitch values every 100ms for 1.5s, then auto-stops.
    private func simulateMicInput() {
        let tone = selectedTone ?? 1
        let fakePitchCurve: [CGFloat] = simulatedPitchCurve(for: tone)
        var index = 0

        // Feed one point every ~100ms
        Task { @MainActor in
            while self.currentState == .recording && index < fakePitchCurve.count {
                self.pitchValues.append(fakePitchCurve[index])
                index += 1
                try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
            }
            // Auto-stop when curve is done
            if self.currentState == .recording {
                self.stopRecordingAndValidate()
            }
        }
    }

    /// Returns a fake pitch contour shaped like the target tone.
    private func simulatedPitchCurve(for tone: Int) -> [CGFloat] {
        switch tone {
        case 1: return [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
        case 2: return [2, 2.5, 3, 3.5, 4, 4.5, 5, 5, 5]
        case 3: return [3, 2.5, 2, 1.5, 1, 1.5, 2, 3, 4]
        case 4: return [5, 4.5, 4, 3, 2, 1, 1, 1]
        default: return [3, 3, 3, 3, 3]
        }
    }
    #endif
}
