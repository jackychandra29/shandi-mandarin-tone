//
//  SingleTonePracticeWord.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import Foundation

struct SingleTonePracticeWord: Identifiable, Codable, Equatable {
    let id: Int
    let hanzi: String
    let pinyin: String
    let meaning: String
    let tone: Int
}
