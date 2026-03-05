import Foundation

final class GetLocalitiesUseCase {
    private let localityRepository: LocalityRepository

    init(localityRepository: LocalityRepository) {
        self.localityRepository = localityRepository
    }

    func execute() async -> Result<[Locality], DomainError> {
        await localityRepository.getLocalities()
    }
}
