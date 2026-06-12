//
//  BigCardLibraryView.swift
//  Shandi
//
//  Created by Jacky Chandra on 05/06/26.
//

import Foundation
import SwiftUI

// MARK: - Helpers

/// Splits "nǐ hǎo" → ["nǐ", "hǎo"]
private func splitSyllables(_ s: String) -> [String] {
    s.components(separatedBy: " ").filter { !$0.isEmpty }
}

/// Splits "3 + 3" → ["3", "3"]  (drops the "+" separators)
private func splitTones(_ s: String) -> [String] {
    s.components(separatedBy: " ").filter { $0 != "+" && !$0.isEmpty }
}

// MARK: - Word Bubble

private struct WordBubble: View {
    let syllable: String
    let tone: String
    let isChanged: Bool

    var body: some View {
        VStack(spacing: 6) {
            Text(syllable)
                .font(Styles.title3Shandi)
                .foregroundColor(Color.text)

            Text(tone)
                .font(Styles.headlineShandi)
                .foregroundColor(Color.orangeBrand)
                .frame(minWidth: 30, minHeight: 30)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: Sizing.roundedSmall)
                .fill(Color.pitchTrack)
                .overlay(
                    RoundedRectangle(cornerRadius: Sizing.roundedSmall)
                        .strokeBorder(
                            Color.orangeBrand,
                            lineWidth: 1.5
                        )
                )
        )
    }
}

// MARK: - Tone Row (Penulisan or Pengucapan)

private struct ToneRow: View {
    let label: String
    let syllables: [String]
    let tones: [String]
    let changedIndices: Set<Int>

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Text(label)
                .font(Styles.headlineShandi)
                .foregroundColor(Color.text)
                .tracking(1.5)
                .textCase(.uppercase)

            HStack(spacing: 10) {
                ForEach(Array(syllables.enumerated()), id: \.offset) { index, syllable in
                    let tone = index < tones.count ? tones[index] : ""
                    let changed = changedIndices.contains(index)

                    WordBubble(syllable: syllable, tone: tone, isChanged: changed)

                    if index < syllables.count - 1 {
                        Text("+")
                            .font(Styles.title3Shandi)
                            .foregroundColor(Color.text.opacity(0.3))
                    }
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            RoundedRectangle(cornerRadius: Sizing.roundedMedium)
                .fill(Color.pitchTrack)
        )
    }
}

// MARK: - Main View

struct BigCardLibraryView: View {
    let data: ToneSandhi
    var speaker: Bool

    /// Figure out which syllable indices changed tone between writing and pronunciation
    private var changedIndices: Set<Int> {
        let wTones = splitTones(data.writingTone)
        let pTones = splitTones(data.pronunciationTone)
        var changed = Set<Int>()
        for i in 0..<min(wTones.count, pTones.count) {
            if wTones[i] != pTones[i] {
                changed.insert(i)
            }
        }
        return changed
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {

                // MARK: Title
                VStack(spacing: 4) {
                    Text(data.rule)
                        .font(Styles.largeTitleShandi)
                        .foregroundColor(Color.text)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(data.ruleExplanation)
                        .font(Styles.subheadlineShandi)
                        .foregroundColor(Color.text.opacity(0.6))
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 4)

                // MARK: Penulisan → Pengucapan
                VStack(spacing: 0) {
                    // Penulisan row (no changes highlighted — original)
                    ToneRow(
                        label: "Penulisan",
                        syllables: splitSyllables(data.writing),
                        tones: splitTones(data.writingTone),
                        changedIndices: []   // no highlight on the original
                    )

                    // Arrow
                    Image(systemName: "arrow.down")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.orangeBrand)
                        .padding(.vertical, 6)

                    // Pengucapan row (highlight changed tones)
                    ToneRow(
                        label: "Pengucapan",
                        syllables: splitSyllables(data.pronunciation),
                        tones: splitTones(data.pronunciationTone),
                        changedIndices: changedIndices
                    )
                }
                .background(
                    RoundedRectangle(cornerRadius: Sizing.roundedBig)
                        .fill(Color.pitchTrack.opacity(0.5))
                )

                // MARK: Contoh (original, unchanged)
                VStack(alignment: .leading, spacing: 12) {
                    Text("Contoh:")
                        .font(Styles.subheadlineShandi)
                        .foregroundColor(Color.text)

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 12
                    ) {
                        ForEach(data.examples) { example in
                            Button(action: {
                                TTSService.shared.speakMandarin(example.hanzi)
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: Icons.speaker)

//                                    Text(example.hanzi)
//                                        .font(Sizing.hanziSmall)

                                    Text(example.writing)
//                                        .font(Styles.captionShandi)
                                }
                                .font(Styles.subheadlineShandi)
                                .foregroundStyle(Color.text)
                                .padding(5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.pillExample)
                                .clipShape(
                                    RoundedRectangle(
                                        cornerRadius: Sizing.roundedBig
                                    )
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, 0)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Sizing.roundedBig))
    }
}

#Preview {
    BigCardLibraryView(
        data: ToneSandhi(
            id: 1,
            rule: "Perubahan Nada 3",
            desc: "Kombinasi dua nada 3.",
            writing: "nǐ hǎo",
            writingTone: "3 + 3",
            pronunciation: "ní hǎo",
            pronunciationTone: "2 + 3",
            ruleExplanation:
                "Jika dua nada 3 bersebelahan, nada pertama berubah menjadi nada 2.",
            why: "Lebih mudah dan cepat diucapkan.",
            examples: [
                ToneSandhiExample(
                    id: 1,
                    hanzi: "你好",
                    writing: "nǐ hǎo",
                    spoken: "ní hǎo",
                    meaning: "halo"
                ),
                ToneSandhiExample(
                    id: 2,
                    hanzi: "水果",
                    writing: "shuǐ guǒ",
                    spoken: "shuí guǒ",
                    meaning: "buah"
                ),
                ToneSandhiExample(
                    id: 3,
                    hanzi: "很好",
                    writing: "hěn hǎo",
                    spoken: "hén hǎo",
                    meaning: "sangat baik"
                ),
                ToneSandhiExample(
                    id: 4,
                    hanzi: "可以",
                    writing: "kě yǐ",
                    spoken: "ké yǐ",
                    meaning: "boleh"
                ),
            ]
        ),
        speaker: false
    )
    .padding()
    .background(Color.screen)
}
