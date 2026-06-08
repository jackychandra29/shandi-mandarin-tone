//
//  LibraryView.swift
//  Shandi
//
//  Created by Jacky Chandra on 28/05/26.
//

import Foundation
import SwiftUI

struct LibraryItem: Identifiable, Decodable {
    let id: Int
    let letter: String
    let desc: String
    let example: String
    let read: String
    let meaning: String
}

struct LibraryView: View {
    @State private var selected = 0

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    let consonants: [Consonant]
    let special_rules: [Consonant]
    let vowels: [Consonant]
    
    let tones: [Tone]
    let tone_sandhi: [ToneSandhi]

    init() {
        consonants =
            JSONLoader.load(
                fileName: "consonants",
                type: [Consonant].self
            ) ?? []
        special_rules =
        JSONLoader.load(
            fileName: "special_rules",
            type: [Consonant].self
        ) ?? []
        
        vowels =
        JSONLoader.load(
            fileName: "vowel",
            type: [Consonant].self
        ) ?? []

        tones =
            JSONLoader.load(
                fileName: "tones",
                type: [Tone].self
            ) ?? []

        tone_sandhi =
            JSONLoader.load(
                fileName: "tone_sandhi",
                type: [ToneSandhi].self
            ) ?? []
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Panduan").font(Styles.largeTitleShandi).padding(
                        .horizontal,
                        30
                    )

                    Picker("Mode", selection: $selected) {
                        Text("Konsonan").tag(0)
                        Text("Nada").tag(1)
                        Text("Aturan").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 16)
                    

                    switch selected {
                    case 0:
                        VStack(alignment: .leading) {
                            Text("Konsonan").font(Styles.title3Shandi)
                            LazyVGrid(columns: columns) {
                                ForEach(consonants) { item in
                                    SmallCardLibraryView(
                                        data: item,
                                        speaker: false,
                                        onPlayMainAudio: {
                                            print(
                                                //"Memutar suara utama untuk \(item.letter)"
                                                TTSService.shared.speakMandarin(item.tts)
                                            )
                                        },
                                        onPlayExampleAudio: {
                                            print(
                                                //"Memutar suara contoh untuk \(item.letter)"
                                                TTSService.shared.speakMandarin(item.hanzi)
                                            )
                                        }
                                    )
                                }
                            }

                            Divider()
                            Text("Vokal").font(Styles.title3Shandi)
                            LazyVGrid(columns: columns) {
                                ForEach(vowels) { item in
                                    SmallCardLibraryView(
                                        data: item,
                                        speaker: false,
                                        onPlayMainAudio: {
                                            print(
                                                //"Memutar suara utama untuk \(item.letter)"
                                                //TTSService.shared.speakMandarin(item.letter)
                                            )
                                        },
                                        onPlayExampleAudio: {
                                            print(
                                                //"Memutar suara contoh untuk \(item.letter)"
                                                TTSService.shared.speakMandarin(item.hanzi)
                                            )
                                        }
                                    )
                                }
                            }
                            
                            Divider()
                            Text("Aturan khusus").font(Styles.title3Shandi)
                            LazyVGrid(columns: columns) {
                                ForEach(special_rules) { item in
                                    SmallCardLibraryView(
                                        data: item,
                                        speaker: true,
                                        onPlayMainAudio: {
                                            print(
                                                //"Memutar suara utama untuk \(item.letter)"
                                                TTSService.shared.speakMandarin(item.letter)
                                            )
                                        },
                                        onPlayExampleAudio: {
                                            print(
                                                //"Memutar suara contoh untuk \(item.letter)"
                                                TTSService.shared.speakMandarin(item.hanzi)
                                            )
                                        }
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                            .background(Color.screen)

                    case 1:
                        VStack {
                            LazyVGrid(columns: columns) {
                                ForEach(tones) { item in
                                    MediumCardLibraryView(
                                        data: item,
                                        speaker: true,
                                        onPlayMainAudio: {
                                            print(
                                                "Memutar suara utama untuk \(item.tts)"
                                            )
                                        },
                                        onPlayExampleAudio: {
                                            print(
                                                //"Memutar suara contoh untuk \(item.example)"
                                                TTSService.shared.speakMandarin(item.hanzi)
                                            )
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 30)
                            .padding(.vertical, 15)
                            
                            HStack {
                                Image("insight")
                                    .resizable()
                                    .frame(width: 71, height: 61)
                                Text(
                                    "Saat berbicara normal, nada 3 sering hanya turun dan tetap rendah. Tidak harus naik lagi. Keduanya benar dan alami."
                                ).font(.caption)
                                    .padding(.horizontal, 10)
                            }.padding()
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: Sizing.roundedSmall)
                                        .foregroundStyle(Color.white)
                                )
                                .padding(.horizontal, 30)
                        }

                    case 2:
                        let cardWidth = geometry.size.width * 0.84

                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 16) {
                                ForEach(tone_sandhi) { item in
                                    BigCardLibraryView(
                                        data: item,
                                        speaker: false
                                    )
                                    .frame(width: cardWidth)
                                }
                            }
                            .frame(maxHeight: .infinity)
                            .scrollTargetLayout()
                            .padding(.horizontal, (geometry.size.width - cardWidth) / 2)
                        }
                        .frame(maxHeight: .infinity)
                        .scrollTargetBehavior(.viewAligned)
                        .scrollIndicators(.hidden)
                    default:
                        EmptyView()
                    }
                }
                .frame(minHeight: geometry.size.height, alignment: .top)
            }
            .background(Color.screen)
        }
    }
}

#Preview {
    LibraryView()
}
