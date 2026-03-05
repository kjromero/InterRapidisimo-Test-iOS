import Foundation

final class SyncTablesUseCase {
    private let tableRepository: TableRepository

    init(tableRepository: TableRepository) {
        self.tableRepository = tableRepository
    }

    func execute() async -> Result<Void, DomainError> {
        await tableRepository.syncTables()
    }
}
