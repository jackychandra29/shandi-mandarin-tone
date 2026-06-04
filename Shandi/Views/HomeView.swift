//
//  HomeView.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ni Hao, User").font(Font.title2.bold())

            Divider()

            Text("Lorem Ipsum").font(.title.bold())
            Text("Welcome to the Shandi App").font(.title2)

            Button {
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "waveform").font(Font.title.bold())
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Practice").font(.headline)
                        Text("Practice single tone").font(
                            Font.subheadline
                        ).foregroundStyle(Color.secondary)

                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(
                        Color.secondary
                    )
                }
                .padding(.vertical, 56)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24).fill(Color.white)
                )
                .shadow(radius: 4)
            }
            .padding(.horizontal)

            Button {
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "waveform").font(Font.title.bold())
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(Color.white)
                        )
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Tone Pair Practice").font(.headline)
                            .foregroundStyle(Color.white)
                        Text("Practice tone combinations").font(
                            Font.subheadline
                        ).foregroundStyle(Color.white)

                    }
                    Spacer()
                    Image(systemName: "chevron.right").foregroundStyle(
                        Color.secondary
                    )
                }
                .padding(.vertical, 56)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 24).fill(
                        Color(red: 1.0, green: 0.45, blue: 0.35, opacity: 0.8)
                    )
                )
                .shadow(radius: 4)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(16)
    }
}

#Preview {
    HomeView()
}
