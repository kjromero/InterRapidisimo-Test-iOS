import Foundation

protocol VersionRepository {
    func getRemoteVersion() async -> Result<String, DomainError>
}
