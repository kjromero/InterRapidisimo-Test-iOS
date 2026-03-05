import Foundation
import SwiftData

final class AuthRepositoryImpl: AuthRepository {
    private let apiClient: InterAPIClient
    private let modelContext: ModelContext

    init(apiClient: InterAPIClient, modelContext: ModelContext) {
        self.apiClient = apiClient
        self.modelContext = modelContext
    }

    func login() async -> Result<User, DomainError> {
        let result = await apiClient.authenticate()
        switch result {
        case .success(let dto):
            let user = User(
                username: dto.username ?? "",
                identification: dto.identification ?? "",
                name: "\(dto.name ?? "") \(dto.lastName1 ?? "") \(dto.lastName2 ?? "")".trimmingCharacters(in: .whitespaces)
            )
            let entity = UserEntity(
                username: user.username,
                identification: user.identification,
                name: user.name
            )
            modelContext.insert(entity)
            try? modelContext.save()
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }

    func getStoredUser() async -> User? {
        let descriptor = FetchDescriptor<UserEntity>()
        guard let entity = try? modelContext.fetch(descriptor).first else {
            return nil
        }
        return User(
            username: entity.username,
            identification: entity.identification,
            name: entity.name
        )
    }
}
