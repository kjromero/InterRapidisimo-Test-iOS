import Foundation

enum HomeUiState {
    case loading
    case ready(User)
    case error
}

@Observable
final class HomeViewModel {
    var uiState: HomeUiState = .loading

    private let getStoredUserUseCase: GetStoredUserUseCase

    init(getStoredUserUseCase: GetStoredUserUseCase) {
        self.getStoredUserUseCase = getStoredUserUseCase
    }

    func loadUser() async {
        if let user = await getStoredUserUseCase.execute() {
            uiState = .ready(user)
        } else {
            uiState = .error
        }
    }
}
