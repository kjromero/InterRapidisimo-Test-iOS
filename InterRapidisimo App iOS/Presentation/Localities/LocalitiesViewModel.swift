import Foundation

enum LocalitiesUiState {
    case loading
    case success([Locality])
    case error(DomainError)
}

@Observable
final class LocalitiesViewModel {
    var uiState: LocalitiesUiState = .loading

    private let getLocalitiesUseCase: GetLocalitiesUseCase

    init(getLocalitiesUseCase: GetLocalitiesUseCase) {
        self.getLocalitiesUseCase = getLocalitiesUseCase
    }

    func loadLocalities() async {
        uiState = .loading
        let result = await getLocalitiesUseCase.execute()

        switch result {
        case .success(let localities):
            uiState = .success(localities)
        case .failure(let error):
            uiState = .error(error)
        }
    }
}
