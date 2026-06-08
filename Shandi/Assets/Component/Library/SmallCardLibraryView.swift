//
//  SmallCard.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 02/06/26.
//

import Foundation
import SwiftUI

struct SmallCardLibraryView: View {
    let data: Consonant
    var speaker: Bool
    var onPlayMainAudio: () -> Void
    var onPlayExampleAudio: () -> Void

    var body: some View {
        VStack {
            HStack {
                Spacer()
            }
            
            // Letter
            HStack(alignment: .center) {
                Text(data.letter)
                    .font(Styles.largeTitleShandi)
                    .foregroundColor(Color.orangeBrand)
            }

            // Desc
            Text(data.desc)
                .font(Styles.captionShandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            // Example
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill").foregroundStyle(Color.text)
                        .font(Styles.subheadlineShandi)
                    Text(data.example)
                        .font(Styles.subheadlineShandi)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundColor(Color.text)

                .background(Color.pillexample)
                .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(Sizing.roundedBig)
        .overlay(alignment: .topTrailing) {
            Image(systemName: Icons.speaker).padding().foregroundStyle(Color.text)
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
