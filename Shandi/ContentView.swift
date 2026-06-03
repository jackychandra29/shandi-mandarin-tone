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
                    Text("Home")
                }
//            PracticeView()
//                .tabItem {
//                    Image(systemName: "mic.fill")
//                    Text("Practice")
//                }
            LibraryView()
                .tabItem {
                    Image(systemName: "character.book.closed.fill")
                    Text("Library")
                }
        }
    }
}

#Preview {
    ContentView()
}
