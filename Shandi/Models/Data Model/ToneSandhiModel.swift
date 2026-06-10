//
//  ToneSandhiModel.swift
//  Shandi
//
//  Created by Jacky Chandra on 02/06/26.
//

import Foundation

struct ToneSandhi: Identifiable, Codable {
    let id: Int
    let rule: String
    let desc: String

    let writing: String
    let writingTone: String

    let pronunciation: String
    let pronunciationTone: String

    let ruleExplanation: String
    let why: String

    let examples: [ToneSandhiExample]
}

struct ToneSandhiExample: Identifiable, Codable {
    let id: Int
    let hanzi: String
    let writing: String
    let spoken: String
    let meaning: String
}
