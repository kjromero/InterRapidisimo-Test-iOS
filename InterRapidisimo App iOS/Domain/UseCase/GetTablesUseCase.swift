import Foundation

final class GetTablesUseCase {
    private let tableRepository: TableRepository

    init(tableRepository: TableRepository) {
        self.tableRepository = tableRepository
    }

    func execute() async -> [Table] {
        await tableRepository.getTables()
    }
}
