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
        VStack(spacing: 8) {
            HStack {
                if speaker {
                    Spacer()
                    Button(action: onPlayMainAudio) {
                        Image(systemName: "speaker.wave.2.fill")
                            .padding(.horizontal, 5)
                    }.foregroundStyle(Color.primary)
                }
                else{
                    Spacer()
                }
            }

            // Letter
            HStack {
                Spacer()
                Text(data.letter)
                    .font(.system(size: 46, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
            }

            // Desc
            Text(data.desc)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(minHeight: 40)

            // Example
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.caption)
                    Text(data.example)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(.primary)

                .background(Color(UIColor.systemGray6))
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        //}

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
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
}
