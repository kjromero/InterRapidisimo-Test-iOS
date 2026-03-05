import Foundation

struct TableSchemeDTO: Decodable {
    let tableName: String?
    let primaryKey: String?
    let createQuery: String?
    let batchSize: Int?
    let filter: String?
    let error: String?
    let fieldCount: Int?
    let appMethod: String?
    let lastSyncDate: String?

    enum CodingKeys: String, CodingKey {
        case tableName = "NombreTabla"
        case primaryKey = "Pk"
        case createQuery = "QueryCreacion"
        case batchSize = "BatchSize"
        case filter = "Filtro"
        case error = "Error"
        case fieldCount = "NumeroCampos"
        case appMethod = "MetodoApp"
        case lastSyncDate = "FechaActualizacionSincro"
    }
}
