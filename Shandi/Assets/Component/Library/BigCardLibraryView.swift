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
    var onPlayMainAudio: () -> Void
    var onPlayExampleAudio: () -> Void

    //    "id": 1,
    //    "rule": "Tone 3 + Tone 3",
    //    "desc": "Tone 3 pertama berubah menjadi Tone 2.",
    //    "example": "你好",
    //    "pinyin": "nǐ hǎo",
    //    "read": "ní hǎo",
    //    "meaning": "halo"

    var body: some View {
        VStack {
            // Title
            HStack {
                Text(data.rule)
                    .font(.largeTitle).bold()
                    .foregroundColor(Color.redBrand)
            }

            Text(data.desc)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            HStack {
                VStack {
                    Text("PENULISAN").font(.caption)
                    Text(data.writing).font(Styles.headlineShandi)
                    Text(data.writingTone).font(.caption)
                }.foregroundStyle(Color.text)
                .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20).foregroundColor(
                            Color.screen
                        )
                    )

                VStack {
                    Text("PENGUCAPAN").font(.caption)
                    Text(data.pronunciation).font(Styles.headlineShandi)
                    Text(data.pronunciationTone).font(.caption)
                }.foregroundStyle(Color.text)
                .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20).foregroundColor(
                            Color.screen
                        )
                    )
            }.padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Aturan").font(Styles.headlineShandi)
                Text(data.ruleExplanation).font(.caption)
            }.padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(
                        Color.screen
                    )
                )
                .padding(.horizontal)
                .foregroundStyle(Color.text)
            
            VStack(alignment: .leading) {
                Text("Kenapa berubah?").font(Styles.headlineShandi)
                Text(data.why).font(.caption)
            }.padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 20).foregroundColor(
                        Color.screen
                    )
                )
                .padding(.horizontal)
                .foregroundStyle(Color.text)

            VStack(alignment: .leading, spacing: 12) {
                Text("Contoh:")
                    .font(.subheadline).fontWeight(.semibold)
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
                            onPlayExampleAudio()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "speaker.wave.2.fill")

                                Text(example.hanzi)
                                    .font(Sizing.hanziSmall)

                                Text(example.writing)
                                    .font(.caption)
                            }
                            .font(.subheadline)
                            .foregroundStyle(Color.text)
                            .padding(5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.pillExample)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
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
        onPlayMainAudio: {
            print("Play main audio")
        },
        onPlayExampleAudio: {
            print("Play example audio")
        }
    )
    .padding()
    .background(Color.screen)
}
