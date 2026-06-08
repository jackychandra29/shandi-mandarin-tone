//
//  TonesModel.swift
//  Shandi
//
//  Created by Jacky Chandra on 02/06/26.
//

struct Tone: Identifiable, Codable {
    let id: Int
    let tone: String
    let symbol: String
    let example: String
    let desc: String
    let meaning: String
    let hanzi: String
    let tts: String
}
