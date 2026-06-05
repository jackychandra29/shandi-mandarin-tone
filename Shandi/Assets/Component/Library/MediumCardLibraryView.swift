//
//  MediumCardView.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 02/06/26.
//

import Foundation
import SwiftUI

//struct SmallModel: Identifiable {
//    let id: String
//    let letter: String
//    let desc: String
//    let example: String
//}

//"id": 1,
//"tone": "Tone 1",
//"symbol": "ˉ",
//"example": "mā",
//"desc": "Nada datar dan tinggi.",
//"meaning": "ibu"

struct MediumCardLibraryView: View {
    let data: Tone
    var speaker: Bool
    var onPlayMainAudio: () -> Void
    var onPlayExampleAudio: () -> Void

    var body: some View {
        //Button(action: onPlayMainAudio) {
        VStack {
            HStack {
                Spacer()
//                if speaker {
//                    Spacer()
//                    Button(action: onPlayMainAudio) {
//                        Image(systemName: "speaker.wave.2.fill")
//                            .padding(.horizontal, 5)
//                    }.foregroundStyle(Color.primary)
//                } else {
//                    Spacer()
//                }
            }

            Text(data.tone)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            // Example
            HStack {
                Text(data.example)
                    .font(.largeTitle).bold()
                    .foregroundColor(Color.redBrand)
            }

            // Desc
            Text(data.desc)
                .font(.subheadline)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            // Button
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.subheadline)
                    Text(data.example)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(Color.text)

                .background(Color.pillExample)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "speaker.wave.2.fill").padding().foregroundStyle(Color.text)
        }
    }
}

#Preview {
    MediumCardLibraryView(
        data: Tone(
            id: 1,
            tone: "Tone 1",
            symbol: "ˉ",
            example: "mā",
            desc: "Nada datar dan tinggi",
            meaning: "ibu"
        ),
        speaker: true,
        onPlayMainAudio: { print("Play b audio") },
        onPlayExampleAudio: { print("Play ba audio") }
    )
    .padding()
    .background(Color.screen)
}
