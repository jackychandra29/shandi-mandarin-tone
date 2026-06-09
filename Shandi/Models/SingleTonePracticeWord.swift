//
//  SingleTonePracticeWord.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import Foundation

struct SingleTonePracticeWord: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let hanzi: String
    let pinyin: String
    let meaning: String
    let tone: Int
    
    var wordKey: String {
        "\(hanzi)-\(pinyin)"
    }

    enum CodingKeys: String, CodingKey {
        case hanzi, pinyin, meaning, tone
    }
}
