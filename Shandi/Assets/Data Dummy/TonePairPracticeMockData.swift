import CoreGraphics

enum TonePairPracticeMockData {
    static let categories: [TonePairPracticeCategory] = [
        TonePairPracticeCategory(
            id: "nada3",
            title: "Perubahan Nada 3",
            subtitle: "Latih saat Nada 3 bertemu dan nada pertama ikut berubah",
            summaryPinyin: "ní hǎo",
            summaryLabel: "NADA 2 + 3",
            words: words
        )
    ]

    static let words: [TonePairPracticeWord] = [
        TonePairPracticeWord(
            pinyin: "nǐ hǎo",
            hanzi: "你好",
            meaning: "Halo",
            tonePair: "Nada 3 + Nada 3",
            question: "nadanya berubah jadi apa?",
            answerOptions: [
                "Nada 2 + Nada 3",
                "Nada 3 + Nada 3",
                "Nada 4 + Nada 3",
                "Nada 1 + Nada 3"
            ],
            correctAnswer: "Nada 2 + Nada 3",
            guidePitch: [2, 3, 3.5, 2, 2.2, 3, 4]
        ),
        TonePairPracticeWord(
            pinyin: "lǎo shǔ",
            hanzi: "老鼠",
            meaning: "Tikus",
            tonePair: "Nada 3 + Nada 3",
            question: "nadanya berubah jadi apa?",
            answerOptions: [
                "Nada 2 + Nada 3",
                "Nada 3 + Nada 3",
                "Nada 4 + Nada 3",
                "Nada 1 + Nada 3"
            ],
            correctAnswer: "Nada 2 + Nada 3",
            guidePitch: [1.5, 3, 3.4, 2.1, 2.4, 3.1, 4]
        )
    ]
}
