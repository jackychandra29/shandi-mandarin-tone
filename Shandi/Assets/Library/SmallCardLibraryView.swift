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

            // Letter
            Text(data.letter)
                .font(Styles.largeTitleShandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)


            // Desc
            Text(data.desc)
                .font(Styles.captionShandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            Spacer()

            // Example
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 4) {
                    Image(systemName: "speaker.wave.2.fill").foregroundStyle(
                        Color.text
                    )
                    .font(Styles.captionShandi)
                    Text(data.example)
                        .font(Styles.captionShandi)
                    Image(systemName: "arrow.right").foregroundStyle(Color.text)
                        .font(Styles.captionShandi)
                    Text(data.read)
                        .font(Styles.captionShandi)
                }
                .padding(8)
                .foregroundColor(Color.text).frame(maxWidth: .infinity)

                .background(Color.pillExample)
                .clipShape(Capsule())
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(Sizing.roundedSmall)
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
            meaning: "ayah",
            hanzi: "test",
            tts: "test"
        ),
        speaker: true,
        onPlayMainAudio: { print("Play b audio") },
        onPlayExampleAudio: { print("Play ba audio") }
    )
    .padding(.horizontal, 30)
    .padding(.vertical, 18)
    .background(Color.screen)
}
