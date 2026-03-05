import Foundation

protocol TableRepository {
    func syncTables() async -> Result<Void, DomainError>
    func getTables() async -> [Table]
}
