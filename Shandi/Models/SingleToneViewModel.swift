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

    func startPractice(for tone: Int) {
        self.selectedTone = tone
        self.loadWords(for: tone)
    }

    func resetToIntro() {
        withAnimation {
            self.selectedTone = nil
            self.currentState = .idle
            self.isSessionComplete = false
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
            // Jika kata habis, selesaikan sesi
            withAnimation { isSessionComplete = true }
            return
        }
        currentWord = wordQueue.removeFirst()
        currentState = .idle
    }
    
    // MARK: - Logic Tombol Microphone
    func toggleRecording() {
        if currentState == .recording {
            stopRecordingAndValidate()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        currentState = .recording
        // TODO: Hubungkan dengan AudioSpeechManager.shared.start()
    }
    
    private func stopRecordingAndValidate() {
        currentState = .analyzing
        // TODO: Hubungkan dengan AudioSpeechManager.shared.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let isCorrect = Bool.random()
            if isCorrect {
                self.currentState = .success
                self.wordsCompleted += 1
            } else {
                self.currentState = .failed
            }
        }
    }
}
