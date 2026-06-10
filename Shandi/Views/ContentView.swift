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
                    Image(systemName: Icons.practice)
                    Text("Latihan")
                }
            LibraryView()
                .tabItem {
                    Image(systemName: Icons.library)
                    Text("Panduan")
                }
        }.tint(Color.orangeBrand)
    }
}

#Preview {
    ContentView()
}
