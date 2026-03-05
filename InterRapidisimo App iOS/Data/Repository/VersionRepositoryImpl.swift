import Foundation

final class VersionRepositoryImpl: VersionRepository {
    private let apiClient: InterAPIClient

    init(apiClient: InterAPIClient) {
        self.apiClient = apiClient
    }

    func getRemoteVersion() async -> Result<String, DomainError> {
        await apiClient.getVersionControl()
    }
}
