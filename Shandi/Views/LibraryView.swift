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
    @State private var selected = 2

    let items = [
        LibraryItem(
            id: 1,
            letter: "b",
            desc: "Seperti 'p'",
            example: "爸 (Bà)",
            read: "pa",
            meaning: "ayah"
        )
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    let consonants: [Consonant]
    let tones: [Tone]
    let tone_sandhi: [ToneSandhi]
    let special_rules: [Consonant]
    let vowels: [Consonant]

    init() {
        consonants =
            JSONLoader.load(
                fileName: "consonants",
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

    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Panduan").font(Font.largeTitle).bold().padding(
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
                        Text("Konsonan").font(.title3).fontWeight(.semibold)
                        LazyVGrid(columns: columns) {
                            ForEach(consonants) { item in
                                SmallCardLibraryView(
                                    data: item,
                                    speaker: true,
                                    onPlayMainAudio: {
                                        print(
                                            "Memutar suara utama untuk \(item.letter)"
                                        )
                                    },
                                    onPlayExampleAudio: {
                                        print(
                                            "Memutar suara contoh untuk \(item.letter)"
                                        )
                                    }
                                )
                            }
                        }

                        Divider()
                        Text("Vokal").font(.title3).fontWeight(.semibold)
                        LazyVGrid(columns: columns) {
                            ForEach(vowels) { item in
                                SmallCardLibraryView(
                                    data: item,
                                    speaker: true,
                                    onPlayMainAudio: {
                                        print(
                                            "Memutar suara utama untuk \(item.letter)"
                                        )
                                    },
                                    onPlayExampleAudio: {
                                        print(
                                            "Memutar suara contoh untuk \(item.letter)"
                                        )
                                    }
                                )
                            }
                        }
                        
                        Divider()
                        Text("Aturan khusus").font(.title3).fontWeight(.semibold)
                        LazyVGrid(columns: columns) {
                            ForEach(special_rules) { item in
                                SmallCardLibraryView(
                                    data: item,
                                    speaker: true,
                                    onPlayMainAudio: {
                                        print(
                                            "Memutar suara utama untuk \(item.letter)"
                                        )
                                    },
                                    onPlayExampleAudio: {
                                        print(
                                            "Memutar suara contoh untuk \(item.letter)"
                                        )
                                    }
                                )
                            }
                        }
                    }.padding(.horizontal, 30)
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
                                            "Memutar suara utama untuk \(item.example)"
                                        )
                                    },
                                    onPlayExampleAudio: {
                                        print(
                                            "Memutar suara contoh untuk \(item.example)"
                                        )
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        
                        HStack {
                            Image(systemName: "arrow.2.circlepath.circle")
                                .resizable()
                                .frame(width: 61, height: 61)
                            Text(
                                "Saat berbicara normal, nada 3 sering hanya turun dan tetap rendah. Tidak harus naik lagi. Keduanya benar dan alami."
                            ).font(.caption)
                                .padding(.horizontal, 10)
                        }.padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.white)
                            )
                            .padding(.horizontal, 30)
                    }

                case 2:
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 20) {
                            ForEach(tone_sandhi) { item in
                                BigCardLibraryView(
                                    data: item,
                                    speaker: false,
                                    onPlayMainAudio: {},
                                    onPlayExampleAudio: {}
                                )
                                .frame(width: 350)
                            }
                        }
                        .scrollTargetLayout()
                        .padding(.horizontal)
                    }
                    
                    .scrollTargetBehavior(.viewAligned)
                    .scrollIndicators(.hidden)
                    
                default:
                    EmptyView()
                }
            }
        }
        .background(Color.screen)
    }
}

#Preview {
    LibraryView()
}
