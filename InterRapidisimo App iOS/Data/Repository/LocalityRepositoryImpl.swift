import Foundation

final class LocalityRepositoryImpl: LocalityRepository {
    private let apiClient: InterAPIClient

    init(apiClient: InterAPIClient) {
        self.apiClient = apiClient
    }

    func getLocalities() async -> Result<[Locality], DomainError> {
        let result = await apiClient.getPickupLocations()
        switch result {
        case .success(let dtos):
            let localities = dtos.map { dto in
                Locality(
                    cityAbbreviation: dto.cityAbbreviation ?? "",
                    fullName: dto.fullName ?? dto.name ?? ""
                )
            }
            return .success(localities)
        case .failure(let error):
            return .failure(error)
        }
    }
}
