//
//  PracticeView.swift
//  Shandi
//
//  Created by Jacky Chandra on 28/05/26.
//

import SwiftUI

struct Flashcard: Identifiable {
    let id = UUID()
    let hanzi: String
    let pinyin: String
}

struct PracticeView: View {

    let cards: [Flashcard] = [
        Flashcard(hanzi: "妈", pinyin: "mā"),
        Flashcard(hanzi: "麻", pinyin: "má"),
        Flashcard(hanzi: "马", pinyin: "mǎ"),
        Flashcard(hanzi: "骂", pinyin: "mà")
    ]

    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero

    var body: some View {

        VStack {

            Text("\(min(currentIndex + 1, cards.count))/\(cards.count)")
                .font(.headline)

            Spacer()

            ZStack {

                // Next card preview
//                if currentIndex + 1 < cards.count {
//                    CardView(card: cards[currentIndex + 1])
//                        .scaleEffect(0.95)
//                        .offset(y: 10)
//                }
                

                // Current card
                if currentIndex < cards.count {
                    CardView(card: cards[currentIndex])
                        .offset(offset)
                        .rotationEffect(.degrees(offset.width / 20))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { value in

                                    if abs(value.translation.width) > 120 {

                                        withAnimation(.spring()) {
                                            offset.width =
                                                value.translation.width > 0
                                                ? 1000 : -1000
                                        }

                                        DispatchQueue.main.asyncAfter(
                                            deadline: .now() + 0.2
                                        ) {
                                            nextCard()
                                        }

                                    } else {
                                        withAnimation(.spring()) {
                                            offset = .zero
                                        }
                                    }
                                }
                        )
                } else {

                    RoundedRectangle(cornerRadius: 30)
                        .fill(.orange.opacity(0.2))
                        .frame(height: 500)
                        .overlay {
                            VStack(spacing: 12) {
                                Text("Finished")
                                    .font(.largeTitle.bold())

                                Text("All cards completed")
                                    .foregroundStyle(.secondary)
                            }
                        }
                }
            }
            .padding(.horizontal)

            Spacer()

            Button {
                swipeNext()
            } label: {
                Text("Next")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()

        }
    }

    private func swipeNext() {

        guard currentIndex < cards.count else { return }

        withAnimation(.spring()) {
            offset.width = -1000
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            nextCard()
        }
    }

    private func nextCard() {
        currentIndex += 1
        offset = .zero
    }
}

struct CardView: View {

    let card: Flashcard

    var body: some View {

        RoundedRectangle(cornerRadius: 30)
            .fill(Color.orange.opacity(0.15))
            .frame(height: 500)
            .overlay {
                VStack(spacing: 20) {

                    Text(card.hanzi)
                        .font(.system(size: 120, weight: .bold))

                    Text(card.pinyin)
                        .font(.title)

                    Image(systemName: "speaker.wave.2.fill")
                        .font(.title2)
                }
                .padding()
            }
            .shadow(radius: 5)
    }
}

#Preview {
    PracticeView()
}
