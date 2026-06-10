//
//  SingleToneType.swift
//  Shandi
//
//  Created by Dody Adi Sancoko on 08/06/26.
//

import Foundation

enum ToneType {
    case flat     // Nada 1
    case rising   // Nada 2
    case dipping  // Nada 3
    case falling  // Nada 4
    case unknown
    
    var chaoValues: [CGFloat] {
        switch self {
        case .flat:
            return [5.0, 5.0]
        case .rising:
            return [3.0, 5.0]
        case .dipping:
            return [2.0, 1.0, 4.0]
        case .falling:
            return [5.0, 1.0]
        case .unknown:
            return []
        }
    }
}
