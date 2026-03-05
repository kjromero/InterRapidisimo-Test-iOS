import Foundation
import SwiftData

@Model
final class TableEntity {
    @Attribute(.unique) var tableName: String
    var primaryKey: String?
    var fieldCount: Int?
    var lastSyncDate: String?

    init(tableName: String, primaryKey: String? = nil, fieldCount: Int? = nil, lastSyncDate: String? = nil) {
        self.tableName = tableName
        self.primaryKey = primaryKey
        self.fieldCount = fieldCount
        self.lastSyncDate = lastSyncDate
    }
}
