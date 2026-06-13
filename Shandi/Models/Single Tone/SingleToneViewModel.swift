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
        audioManager.startRecording(targetTone: selectedTone ?? 1)
    }

    private func stopRecordingAndValidate() {
        currentState = .analyzing

        guard let word = currentWord, let tone = selectedTone else {
            currentState = .failed
            return
        }

        let result = audioManager.stopRecording(targetWord: word, targetTone: tone)
        self.lastValidationResult = result

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if result.isFullyCorrect {
                self.currentState = .success
                self.wordsCompleted += 1
            } else {
                self.currentState = .failed
            }
        }
    }
}
