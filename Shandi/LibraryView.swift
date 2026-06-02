//
//  LibraryView.swift
//  Shandi
//
//  Created by Jacky Chandra on 28/05/26.
//

import SwiftUI

struct LibraryItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}

struct LibraryView: View {
    @State private var selected = 0

    let items = [
        LibraryItem(title: "Practice", subtitle: "Single Tone"),
        LibraryItem(title: "Tone Pair", subtitle: "Combinations"),
        LibraryItem(title: "Challenge", subtitle: "Daily Practice"),
        LibraryItem(title: "Library", subtitle: "All Lessons"),
        LibraryItem(title: "Practice", subtitle: "Single Tone"),
        LibraryItem(title: "Tone Pair", subtitle: "Combinations"),
        LibraryItem(title: "Challenge", subtitle: "Daily Practice"),
        LibraryItem(title: "Library", subtitle: "All Lessons"),
        LibraryItem(title: "Practice", subtitle: "Single Tone"),
        LibraryItem(title: "Tone Pair", subtitle: "Combinations"),
        LibraryItem(title: "Challenge", subtitle: "Daily Practice"),
        LibraryItem(title: "Library", subtitle: "All Lessons"),
        LibraryItem(title: "Practice", subtitle: "Single Tone"),
        LibraryItem(title: "Tone Pair", subtitle: "Combinations"),
        LibraryItem(title: "Challenge", subtitle: "Daily Practice"),
        LibraryItem(title: "Library", subtitle: "All Lessons"),
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Library").font(Font.title).bold().padding(10)

                Divider()

                Picker("Mode", selection: $selected) {
                    Text("Single Tone").tag(0)
                    Text("Tone Pair").tag(1)
                    Text("Phonetics").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 10)

                switch selected {
                case 0:
                    Text("Single Tone View")
                case 1:
                    Text("Tone Pair View")
                case 2:
                    Text("Sentence View")
                default:
                    EmptyView()
                }
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items) { item in

                        Button {

                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image(systemName: "waveform").font(
                                    Font.largeTitle.bold()
                                ).frame(
                                    maxWidth: .infinity,
                                    maxHeight: .infinity
                                ).background(
                                    RoundedRectangle(cornerRadius: 20).fill(
                                        .orange
                                    )
                                ).padding(10)

                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity,
                                alignment: .topLeading
                            )
                            .padding()
                        }
                        .frame(height: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                        )
                        .shadow(radius: 10)
                    }
                }
                .padding(16)
            }

        }
    }
}

#Preview {
    LibraryView()
}
