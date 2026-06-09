//
//  ShandiApp.swift
//  Shandi
//
//  Created by Jacky Chandra on 26/05/26.
//

import SwiftData
import SwiftUI

@main
struct ShandiApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(for: PracticeProgress.self)
    }
}
