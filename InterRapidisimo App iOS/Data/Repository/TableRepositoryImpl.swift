import Foundation
import SwiftData

final class TableRepositoryImpl: TableRepository {
    private let apiClient: InterAPIClient
    private let modelContext: ModelContext

    init(apiClient: InterAPIClient, modelContext: ModelContext) {
        self.apiClient = apiClient
        self.modelContext = modelContext
    }

    func syncTables() async -> Result<Void, DomainError> {
        let result = await apiClient.getSchema()
        switch result {
        case .success(let dtos):
            // Delete all existing tables
            try? modelContext.delete(model: TableEntity.self)

            // Insert new tables
            for dto in dtos {
                let entity = TableEntity(
                    tableName: dto.tableName ?? "",
                    primaryKey: dto.primaryKey,
                    fieldCount: dto.fieldCount,
                    lastSyncDate: dto.lastSyncDate
                )
                modelContext.insert(entity)
            }
            try? modelContext.save()
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    func getTables() async -> [Table] {
        let descriptor = FetchDescriptor<TableEntity>()
        guard let entities = try? modelContext.fetch(descriptor) else {
            return []
        }
        return entities.map { entity in
            Table(
                tableName: entity.tableName,
                primaryKey: entity.primaryKey,
                fieldCount: entity.fieldCount,
                lastSyncDate: entity.lastSyncDate
            )
        }
    }
}
