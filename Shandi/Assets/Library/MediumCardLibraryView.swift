//
//  MediumCardView.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 02/06/26.
//

import Foundation
import SwiftUI

struct MediumCardLibraryView: View {
    let data: Tone
    var speaker: Bool
    var onPlayMainAudio: () -> Void
    var onPlayExampleAudio: () -> Void

    var body: some View {
        VStack {
            Text(data.tone)
                .font(Styles.headlineShandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            // Example
                Text(data.example)
                    .font(Styles.largeTitleShandi)
                    .foregroundColor(Color.text)

            // Desc
            Text(data.desc)
                .font(Styles.subheadlineShandi)
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            Spacer()

            // Button
            Button(action: onPlayExampleAudio) {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill")
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(Sizing.roundedMedium)
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
            meaning: "ibu",
            hanzi: "test",
            tts: "test lagi"
        ),
        speaker: true,
        onPlayMainAudio: { print("Play b audio") },
        onPlayExampleAudio: { print("Play ba audio") }
    )
    .padding()
    .background(Color.screen)
}
