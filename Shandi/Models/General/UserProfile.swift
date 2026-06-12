import Foundation
import SwiftData

@Model
final class UserProfile {
    var name: String = ""
    var updatedAt: Date = Date()

    init(name: String) {
        self.name = name
        self.updatedAt = Date()
    }
}
