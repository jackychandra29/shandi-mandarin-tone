//
//  HomeView.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import Lottie
import SwiftData
import SwiftUI

struct HomeView: View {
    @Query(sort: \UserProfile.updatedAt, order: .reverse) private
        var userProfiles: [UserProfile]

    private var userName: String {
        let name =
            userProfiles.first?.name.trimmingCharacters(
                in: .whitespacesAndNewlines
            ) ?? ""
        return name.isEmpty ? "User" : name
    }

    @State private var textVisible = false

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geo in
                    let animW: CGFloat = 1080
                    let animH: CGFloat = 2340
                    let scaleX = geo.size.width / animW
                    let scaleY = geo.size.height / animH
                    let scale = max(scaleX, scaleY)

                    LottieView(animation: .named("HomeScreenNaga"))
                        .playing(loopMode: .playOnce)
                        .resizable()
                        .frame(width: animW * scale, height: animH * scale)
                        .offset(
                            x: (geo.size.width - animW * scale) / 2,
                            y: (geo.size.height - animH * scale) / 2
                        )
                        .clipped()
                }
                .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {

                    // ── TOP: greeting text, hidden then pops in ──
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ni Hao, \(userName)").font(
                            Styles.subheadlineShandi
                        )
                        Text("Yuk, Latih Nada Mandarinmu").font(
                            Styles.largeTitleShandi
                        )
                    }
                    .foregroundStyle(Color.redBrand)
                    .padding()
                    .opacity(textVisible ? 1 : 0)
                    .offset(y: textVisible ? -30 : -20)
                    .onAppear {
                        // Task allows us to use 'sleep' for the delay
                        Task {
                            // 1. Wait for 7 seconds (7 billion nanoseconds)
                            try? await Task.sleep(nanoseconds: 7_000_000_000)

                            // 2. Run the animation after the wait is over
                            withAnimation(.bouncy(duration: 2)) {
                                textVisible = true
                            }
                        }
                    }

                    Spacer()

                    // ── BOTTOM: buttons ──
                    NavigationLink(destination: SingleToneView()) {
                        HStack {
                            Image("singlePractice").resizable().frame(
                                width: 65,
                                height: 65
                            )

                            VStack(alignment: .leading) {
                                Text("Nada Dasar").font(Font.title3).bold()
                                Text(
                                    "Dengar, ikuti, lalu ulangi setiap nada satu per satu."
                                ).font(Styles.captionShandi)
                                    .multilineTextAlignment(.leading)

                            }.foregroundStyle(Color.white).padding(
                                .horizontal,
                                8
                            )

                            Spacer()

                            Image(systemName: "chevron.right").foregroundStyle(
                                Color.white
                            )
                        }.padding(.vertical, 34)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 24).fill(
                                    Color.redBrand
                                ).shadow(
                                    color: Color.redShadow,
                                    radius: 0,
                                    y: 4
                                )
                            )
                    }

                    NavigationLink(destination: TonePairView()) {
                        HStack {
                            Image("pairPractice").resizable().frame(
                                width: 65,
                                height: 65
                            )

                            VStack(alignment: .leading) {
                                Text("Gabungan Nada").font(Font.title3).bold()
                                Text(
                                    "Dengar, bandingkan, lalu ikuti pola gabungan nadanya."
                                ).font(Styles.captionShandi)
                                    .multilineTextAlignment(.leading)

                            }.foregroundStyle(Color.white).padding(
                                .horizontal,
                                8
                            )

                            Spacer()

                            Image(systemName: "chevron.right").foregroundStyle(
                                Color.white
                            )
                        }.padding(.vertical, 34)
                            .padding(.horizontal, 15)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 24).fill(
                                    Color.orangeBrand
                                ).shadow(
                                    color: Color.orangeShadow,
                                    radius: 0,
                                    y: 4
                                )
                            )
                            .padding(.bottom, 0)
                    }
                }
                .padding(30)
            }
            .task {
                try? await Task.sleep(nanoseconds: 7_000_000_000)  // 2 seconds
                textVisible = true
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(
            for: [PracticeAnswer.self, UserProfile.self],
            inMemory: true
        )
}
