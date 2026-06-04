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

    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Library").font(Font.title).bold().padding(10)

                Divider()

                Picker("Mode", selection: $selected) {
                    Text("Konsonan").tag(0)
                    Text("Nada").tag(1)
                    Text("Aturan").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)

                switch selected {
                case 0:
                    LazyVGrid(columns: columns, spacing: 16) {
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
                    .padding(16)
                    .background(Color(UIColor.systemGroupedBackground))
                    Divider()
                    Text("Special Rules").font(.title).fontWeight(.semibold)
                        .padding(.horizontal, 20)
                    LazyVGrid(columns: columns, spacing: 16) {
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
                    }.padding(16)
                        .background(Color(UIColor.systemGroupedBackground))
                case 1:
                    VStack {
                        LazyVGrid(columns: columns, spacing: 16) {
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
                        .padding(16)

                        HStack(spacing: 10) {
                            Image(systemName: "arrow.2.circlepath.circle")
                                .resizable()
                                .frame(width: 61, height: 61)
                            Text(
                                "Saat berbicara normal, nada 3 sering hanya turun dan tetap rendah. Tidak harus naik lagi. Keduanya benar dan alami."
                            ).font(.caption2)
                        }.padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.gray)
                            )
                            .padding(.horizontal)
                    }.background(Color(UIColor.systemGroupedBackground))

                case 2:
                    Text("Sentence View")
                default:
                    EmptyView()
                }

            }

        }
    }
}

#Preview {
    LibraryView()
}
