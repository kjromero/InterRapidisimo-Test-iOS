import Foundation
import SwiftData

@Model
final class UserEntity {
    @Attribute(.unique) var username: String
    var identification: String
    var name: String

    init(username: String, identification: String, name: String) {
        self.username = username
        self.identification = identification
        self.name = name
    }
}
