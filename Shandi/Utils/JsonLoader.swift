//
//  JsonLoader.swift
//  Shandi
//
//  Created by Jacky Chandra on 02/06/26.
//

import Foundation

final class JSONLoader {

    static func load<T: Decodable>(
        fileName: String,
        type: T.Type
    ) -> T? {

        guard let url = Bundle.main.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
