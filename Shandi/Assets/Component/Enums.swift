//
//  Sizing.swift
//  Shandi
//
//  Created by Jacky Chandra on 05/06/26.
//

import Foundation
import SwiftUI

// For font size and radius corners
enum Sizing {
    static let hanziLarge = Font.system(size: 60)
    static let hanziSmall = Font.system(size: 15)
    
    static let roundedSmall = 20
    static let roundedMedium = 16
    static let roundedBig = 12
}

// For icons used in the app
enum Icons {
    static let speaker = "speaker.wave.2.fill"
    static let close = "x.circle.fill"
    static let mic = "microphone.circle.fill"
}

// For font styles used in the app
enum Styles {
    static let largeTitleShandi = Font.system(.largeTitle).bold()
    static let title2Shandi = Font.system(.title2).bold()
    static let title3Shandi = Font.system(.title3, weight: .semibold)
    static let headlineShandi = Font.system(.headline, weight: .semibold)
}


