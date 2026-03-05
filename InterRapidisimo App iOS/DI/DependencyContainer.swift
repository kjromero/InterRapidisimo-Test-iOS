import Foundation
import SwiftData

final class DependencyContainer {
    static let shared = DependencyContainer()

    private init() {}

    // MARK: - SwiftData

    lazy var modelContainer: ModelContainer = {
        do {
            let schema = Schema([UserEntity.self, TableEntity.self])
            let configuration = ModelConfiguration(schema: schema)
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }()

    private var modelContext: ModelContext {
        ModelContext(modelContainer)
    }

    // MARK: - Remote

    private lazy var apiClient = InterAPIClient()

    // MARK: - Repositories

    private func makeVersionRepository() -> VersionRepository {
        VersionRepositoryImpl(apiClient: apiClient)
    }

    private func makeAuthRepository() -> AuthRepository {
        AuthRepositoryImpl(apiClient: apiClient, modelContext: modelContext)
    }

    private func makeTableRepository() -> TableRepository {
        TableRepositoryImpl(apiClient: apiClient, modelContext: modelContext)
    }

    private func makeLocalityRepository() -> LocalityRepository {
        LocalityRepositoryImpl(apiClient: apiClient)
    }

    // MARK: - Use Cases

    private func makeCheckVersionUseCase() -> CheckVersionUseCase {
        CheckVersionUseCase(versionRepository: makeVersionRepository())
    }

    private func makeLoginUseCase() -> LoginUseCase {
        LoginUseCase(authRepository: makeAuthRepository())
    }

    private func makeSyncTablesUseCase() -> SyncTablesUseCase {
        SyncTablesUseCase(tableRepository: makeTableRepository())
    }

    private func makeGetTablesUseCase() -> GetTablesUseCase {
        GetTablesUseCase(tableRepository: makeTableRepository())
    }

    private func makeGetLocalitiesUseCase() -> GetLocalitiesUseCase {
        GetLocalitiesUseCase(localityRepository: makeLocalityRepository())
    }

    private func makeGetStoredUserUseCase() -> GetStoredUserUseCase {
        GetStoredUserUseCase(authRepository: makeAuthRepository())
    }

    // MARK: - ViewModels

    func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(
            checkVersionUseCase: makeCheckVersionUseCase(),
            loginUseCase: makeLoginUseCase(),
            getStoredUserUseCase: makeGetStoredUserUseCase()
        )
    }

    func makeHomeViewModel() -> HomeViewModel {
        HomeViewModel(getStoredUserUseCase: makeGetStoredUserUseCase())
    }

    func makeTablasViewModel() -> TablasViewModel {
        TablasViewModel(
            syncTablesUseCase: makeSyncTablesUseCase(),
            getTablesUseCase: makeGetTablesUseCase()
        )
    }

    func makeLocalitiesViewModel() -> LocalitiesViewModel {
        LocalitiesViewModel(getLocalitiesUseCase: makeGetLocalitiesUseCase())
    }
}
