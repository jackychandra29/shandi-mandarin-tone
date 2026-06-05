//
//  SmallCard.swift
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

struct SmallCardLibraryView: View {
    let data: Consonant
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
//                }
//                else{
//                    Spacer()
//                }
            }

            // Letter
            HStack(alignment: .center) {
                Text(data.letter)
                    .font(Font.largeTitle).bold()
                    .foregroundColor(Color.orange)
            }

            // Desc
            Text(data.desc)
                .font(.caption)
                .foregroundColor(.text)
                .multilineTextAlignment(.center)

            // Example
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill").foregroundStyle(Color.text)
                        .font(.subheadline)
                    Text(data.example)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(.text)

                .background(Color.pillexample)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "speaker.wave.2.fill").padding().foregroundStyle(Color.text)
        }
    }
}

#Preview {
    SmallCardLibraryView(
        data: Consonant(
            id: 1,
            letter: "b",
            desc: "Seperti 'p'",
            example: "bā",
            read: "pa",
            meaning: "ayah"
        ),
        speaker: true,
        onPlayMainAudio: { print("Play b audio") },
        onPlayExampleAudio: { print("Play ba audio") }
    )
    .padding(.horizontal, 30)
    .padding(.vertical, 18)
    .background(Color.screen)
}
