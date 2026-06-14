//
//  PracticeHeader.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import SwiftUI

struct PracticeHeader: View {
    let title: String
    let subtitle: String

    let onExitTap: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 2) {
                Text(title)
                    .font(Styles.headlineShandi)
                    .foregroundStyle(Color.text)
                    .lineLimit(1)

                Text(subtitle)
                    .font(Styles.captionShandi)
                    .foregroundStyle(Color.text)
                    .lineLimit(1)

                Rectangle()
                    .fill(Color.text.opacity(0.35))
                    .frame(height: 1)
            }

            HStack {
                Spacer()

                Button(action: onExitTap) {
                    Image(systemName: Icons.close)
                        .font(.system(size: 32, design: .rounded))
                        .foregroundStyle(Color.text)
                        .frame(width: 34, height: 34)
                }
            }
        }
        //        .frame(height: 16)
        .padding(.horizontal, 22)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .top)
        .padding(.top, 20)
    }
}

#Preview {
    VStack {
        PracticeHeader(
            title: "Nada 1 - Stabil",
            subtitle: "Kata ke-1 dari sesi latihanmu",
            onExitTap: {
                print("Tombol exit diklik")
            }
        )
        Spacer()
    }
    .background(Color(.systemGroupedBackground))
}
