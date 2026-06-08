//
//  BigCardLibraryView.swift
//  Shandi
//
//  Created by Jacky Chandra on 05/06/26.
//

import Foundation
import SwiftUI

struct BigCardLibraryView: View {
    let data: ToneSandhi
    var speaker: Bool

    var body: some View {
        VStack {
            // Title
            HStack {
                Text(data.rule)
                    .font(Styles.largeTitleShandi)
                    .foregroundColor(Color.redBrand)
            }

            Text(data.desc)
                .font(Styles.title3Shandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            HStack {
                VStack {
                    Text("PENULISAN").font(Styles.captionShandi)
                    Text(data.writing).font(Styles.headlineShandi)
                    Text(data.writingTone).font(Styles.captionShandi)
                }.foregroundStyle(Color.text)
                .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Sizing.roundedBig).foregroundColor(
                            Color.pitchtrack
                        )
                    )

                VStack {
                    Text("PENGUCAPAN").font(Styles.captionShandi)
                    Text(data.pronunciation).font(Styles.headlineShandi)
                    Text(data.pronunciationTone).font(Styles.captionShandi)
                }.foregroundStyle(Color.text)
                .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Sizing.roundedBig).foregroundColor(
                            Color.pitchtrack
                        )
                    )
            }.padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Aturan").font(Styles.headlineShandi)
                Text(data.ruleExplanation).font(Styles.captionShandi)
            }.padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Sizing.roundedBig).foregroundColor(
                        Color.pitchtrack
                    )
                )
                .padding(.horizontal)
                .foregroundStyle(Color.text)
            
            VStack(alignment: .leading) {
                Text("Kenapa berubah?").font(Styles.headlineShandi)
                Text(data.why).font(Styles.captionShandi)
            }.padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: Sizing.roundedBig).foregroundColor(
                        Color.pitchtrack
                    )
                )
                .padding(.horizontal)
                .foregroundStyle(Color.text)

            VStack(alignment: .leading, spacing: 12) {
                Text("Contoh:")
                    .font(Styles.subheadlineShandi)
                    .foregroundColor(Color.text)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 12
                ) {
                    ForEach(data.examples) { example in
                        Button(action: {
                            TTSService.shared.speakMandarin(example.hanzi)                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: Icons.speaker)

                                Text(example.hanzi)
                                    .font(Sizing.hanziSmall)

                                Text(example.writing)
                                    .font(Styles.captionShandi)
                            }
                            .font(Styles.subheadlineShandi)
                            .foregroundStyle(Color.text)
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.pillexample)
                            .clipShape(RoundedRectangle(cornerRadius: Sizing.roundedMedium))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.white)
        .cornerRadius(Sizing.roundedSmall)
    }
}

#Preview {
    BigCardLibraryView(
        data: ToneSandhi(
            id: 1,
            rule: "Tone 3 + Tone 3",
            desc: "Kombinasi dua nada 3.",
            writing: "nǐ hǎo",
            writingTone: "3 + 3",
            pronunciation: "ní hǎo",
            pronunciationTone: "2 + 3",
            ruleExplanation: "Jika dua nada 3 bersebelahan, nada pertama berubah menjadi nada 2.",
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
                    hanzi: "很好",
                    writing: "hěn hǎo",
                    spoken: "hén hǎo",
                    meaning: "sangat baik"
                ),
                ToneSandhiExample(
                    id: 3,
                    hanzi: "你好",
                    writing: "nǐ hǎo hao",
                    spoken: "ní hǎo",
                    meaning: "halo"
                ),
                ToneSandhiExample(
                    id: 4,
                    hanzi: "很好",
                    writing: "hěn hǎo",
                    spoken: "hén hǎo",
                    meaning: "sangat baik"
                )
            ]
        ),
        speaker: false,
    )
    .padding()
    .background(Color.screen)
}
