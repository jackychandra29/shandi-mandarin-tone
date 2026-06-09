//
//  HomeView.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("userName") private var userName = "User"

    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundd")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Spacer()
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Ni Hao, \(userName)").font(Styles.subheadlineShandi)
                        Text("Yuk, Latih Nada Mandarinmu").font(
                            Styles.largeTitleShandi
                        )
                    }.foregroundStyle(Color.redBrand)
                        .padding()

                    Spacer()

                    HStack {
                        Spacer()
                        Image("asan").resizable()
                            .frame(width: 150, height: 200)
                    }.padding(.vertical, 5)

                    //Button single tone
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
                                )
                            )
                    }
//                    Button {
//                    } label: {
//                        HStack {
//                            Image("singlePractice").resizable().frame(
//                                width: 65,
//                                height: 65
//                            )
//
//                            VStack(alignment: .leading) {
//                                Text("Nada Dasar").font(Font.title3).bold()
//                                Text(
//                                    "Dengar, ikuti, lalu ulangi setiap nada satu per satu."
//                                ).font(Styles.captionShandi)
//                                    .multilineTextAlignment(.leading)
//                            }.foregroundStyle(Color.white).padding(
//                                .horizontal,
//                                8
//                            )
//
//                            Spacer()
//
//                            Image(systemName: "chevron.right").foregroundStyle(
//                                Color.white
//                            )
//                        }.padding(.vertical, 34)
//                            .padding(.horizontal, 15)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .background(
//                                RoundedRectangle(cornerRadius: 24).fill(
//                                    Color.redBrand
//                                )
//                            )
//                    }

                    //Button pair tone
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
                                )
                            )
                            .padding(.bottom, 80)
                    }
                }
                .padding(30)
            }
        }
    }
}

#Preview {
    HomeView()
}
