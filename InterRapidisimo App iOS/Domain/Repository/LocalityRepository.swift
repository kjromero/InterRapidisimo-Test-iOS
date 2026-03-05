import Foundation

protocol LocalityRepository {
    func getLocalities() async -> Result<[Locality], DomainError>
}
