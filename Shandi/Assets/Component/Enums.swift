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
    
    static let roundedSmall :CGFloat = 12
    static let roundedMedium :CGFloat = 16
    static let roundedBig :CGFloat = 20
}

// For icons used in the app
enum Icons {
    static let speaker = "speaker.wave.2.fill"
    static let close = "x.circle.fill"
    static let mic = "microphone.circle.fill"
}

// For font styles used in the app
enum Styles {
    static let largeTitleShandi = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let title2Shandi = Font.system(.title2, design: .rounded, weight: .bold)
    static let title3Shandi = Font.system(.title3, design: .rounded, weight: .semibold)
    static let headlineShandi = Font.system(.headline, design: .rounded, weight: .semibold)
    static let bodyShandi = Font.system(.body, design: .rounded, weight: .regular)
    static let subheadlineShandi = Font.system(.subheadline, design: .rounded, weight: .regular)
    static let captionShandi = Font.system(.caption, design: .rounded, weight: .regular)
    static let caption2Shandi = Font.system(.caption2, design: .rounded, weight: .regular)
}
