//
//  HomeView.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Halo, User").font(Font.title2.bold())

                Divider()

                Text("Latihan hari ini").font(.title.bold())
                Text("Selamat datang di aplikasi Shandi").font(.title2)

                Button {
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "waveform").font(Font.title.bold())
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latihan").font(.headline)
                            Text("Latihan nada tunggal").font(
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
                        RoundedRectangle(cornerRadius: 24).fill(Color.pitchtrack)
                    )
                    .shadow(radius: 4)
                }
                .padding(.horizontal)

                NavigationLink {
                    TonePairView()
                } label: {
                    HStack(spacing: 16) {
                        Image(systemName: "waveform").font(Font.title.bold())
                            .background(
                                RoundedRectangle(cornerRadius: 10).fill(Color.screen)
                            )
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Latihan Pasangan Nada").font(.headline)
                                .foregroundStyle(Color.screen)
                            Text("Latih kombinasi nada").font(
                                Font.subheadline
                            ).foregroundStyle(Color.screen)

                        }
                        Spacer()
                        Image(systemName: "chevron.right").foregroundStyle(
                            Color.screen
                        )
                    }
                    .padding(.vertical, 56)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 24).fill(
                            Color.orangeBrand
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
}

#Preview {
    HomeView()
    
}
