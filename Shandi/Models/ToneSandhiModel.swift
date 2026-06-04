//
//  ToneSandhiModel.swift
//  Shandi
//
//  Created by Jacky Chandra on 02/06/26.
//

struct ToneSandhi: Identifiable, Codable {
    let id: Int
    let rule: String
    let desc: String
    let example: String
    let pinyin: String
    let read: String
    let meaning: String
}
