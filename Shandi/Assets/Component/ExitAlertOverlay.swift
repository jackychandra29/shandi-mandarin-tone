//
//  ExitAlertOverlay.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 09/06/26.
//

import SwiftUI

struct ExitAlertOverlay: View {
    let wordCount: Int
    let onExit: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 2) {
                Text("Akhiri latihan?")
                    .font(Styles.largeTitleShandi)
                    .foregroundStyle(Color.redBrand)
                    .padding(.top, 16)

                Image("dragonhi")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)

                Text("Hari ini kamu sudah latihan \(wordCount) kata\nProgresmu sudah tersimpan.")
                    .font(Styles.bodyShandi)
                    .foregroundStyle(Color.text)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 16)
                
                HStack(spacing: 12) {
                    Button(action: onExit) {
                        Text("Akhiri sesi")
                            .font(Styles.headlineShandi)
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.screen)
                            .clipShape(Capsule())
                    }

                    Button(action: onContinue) {
                        Text("Lanjut")
                            .font(Styles.headlineShandi)
                            .foregroundStyle(Color.text)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.yellowBrand)
                            .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 12)
            }
            .padding(.horizontal, 26)
            .padding(.vertical, 28)
            .frame(maxWidth: 340)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    ExitAlertOverlay(wordCount: 10, onExit: {}, onContinue: {})
}
