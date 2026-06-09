//
//  ContentView.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Beranda")
                }
            LibraryView()
                .tabItem {
                    Image(systemName: "character.book.closed.fill")
                    Text("Pustaka")
                }
        }.tint(Color.orangeBrand)
    }
}

#Preview {
    ContentView()
}
