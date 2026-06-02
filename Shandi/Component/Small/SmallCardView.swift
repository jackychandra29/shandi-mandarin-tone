//
//  SmallCard.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 02/06/26.
//

import SwiftUI
import Foundation

struct SmallModel: Identifiable {
    let id: String
    let letter: String
    let desc: String
    let example: String
}

struct SmallCardView: View {
    let data: SmallModel
    
    var onPlayMainAudio: () -> Void
    var onPlayExampleAudio: () -> Void

    var body: some View {
        //Button(action: onPlayMainAudio) {
            VStack(spacing: 8) {
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
   SmallCardView(
        data: SmallModel(
            id: "b",
            letter: "b",
            desc: "Like \"b\" in book\nno air puff",
            example: "bā"
        ),
        onPlayMainAudio: { print("Play b audio") },
        onPlayExampleAudio: { print("Play ba audio") }
    )
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
}

