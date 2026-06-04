//
//  MediumCard.swift
//  Shandi
//
//  Created by Jacky Chandra on 02/06/26.
//

import SwiftUI

struct ToneCardView: View {

    let speaker: Bool
    let tone: String
    let pinyin: String
    let description: String
    let practicedWords: Int
    let totalWords: Int

    private var progress: Double {
        Double(practicedWords) / Double(totalWords)
    }

    var body: some View {

        VStack {
            if speaker {
                HStack {
                    Spacer()
                    Image(systemName: "speaker.wave.2.fill")
                }.padding(.horizontal)
                    .padding(.top, 10)
            }else {
                Spacer()
            }

            Text(tone)
                .font(.headline).bold()
                .foregroundStyle(.gray)
            
            Text(pinyin)
                .font(.largeTitle).bold()
                .foregroundStyle(.black)

            Text(description)
                .font(.callout)
                .foregroundStyle(.gray)

            VStack {

                GeometryReader { geometry in

                    ZStack(alignment: .leading) {

                        Capsule()
                            .fill(Color.gray.opacity(0.2))

                        Capsule()
                            .fill(Color.gray.opacity(0.8))
                            .frame(
                                width: geometry.size.width * progress
                            )
                    }
                }
                .frame(height: 8)

                Text("\(practicedWords)/\(totalWords) words practiced")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 10)

            Spacer()
        }
        .frame(maxWidth: 163)
        .frame(height: 199)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(Color.white)
        )
        .padding()
        .fontDesign(.rounded)
    }
}

#Preview {
    ZStack {

        Color(.systemGray6)
            .ignoresSafeArea()

        ToneCardView(
            speaker: false,
            tone: "Tone 1",
            pinyin: "mā",
            description: "The flat one",
            practicedWords: 10,
            totalWords: 100
        )
    }
}
