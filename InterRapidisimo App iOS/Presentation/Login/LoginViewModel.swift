import Foundation

enum LoginUiState {
    case initializing
    case ready(LoginReadyState)
}

struct LoginReadyState {
    var versionStatus: VersionStatus? = nil
    var showVersionDialog: Bool = false
    var isLoginLoading: Bool = false
    var error: DomainError? = nil
}

enum LoginEvent {
    case navigateToHome
}

@Observable
final class LoginViewModel {
    var uiState: LoginUiState = .initializing
    var navigationEvent: LoginEvent? = nil

    private let checkVersionUseCase: CheckVersionUseCase
    private let loginUseCase: LoginUseCase
    private let getStoredUserUseCase: GetStoredUserUseCase

    init(
        checkVersionUseCase: CheckVersionUseCase,
        loginUseCase: LoginUseCase,
        getStoredUserUseCase: GetStoredUserUseCase
    ) {
        self.checkVersionUseCase = checkVersionUseCase
        self.loginUseCase = loginUseCase
        self.getStoredUserUseCase = getStoredUserUseCase
    }

    func initialize() async {
        async let versionResult = checkVersionUseCase.execute()
        async let storedUser = getStoredUserUseCase.execute()

        let user = await storedUser
        let version = await versionResult

        if user != nil {
            navigationEvent = .navigateToHome
            return
        }

        var readyState = LoginReadyState()

        switch version {
        case .success(let status):
            readyState.versionStatus = status
            switch status {
            case .localIsOutdated, .localIsNewer:
                readyState.showVersionDialog = true
            case .match:
                break
            }
        case .failure:
            break
        }

        uiState = .ready(readyState)
    }

    func login() async {
        guard case .ready(var state) = uiState else { return }
        state.isLoginLoading = true
        state.error = nil
        uiState = .ready(state)

        let result = await loginUseCase.execute()

        guard case .ready(var updatedState) = uiState else { return }
        updatedState.isLoginLoading = false

        switch result {
        case .success:
            uiState = .ready(updatedState)
            navigationEvent = .navigateToHome
        case .failure(let error):
            updatedState.error = error
            uiState = .ready(updatedState)
        }
    }

    func dismissError() {
        guard case .ready(var state) = uiState else { return }
        state.error = nil
        uiState = .ready(state)
    }

    func dismissVersionDialog() {
        guard case .ready(var state) = uiState else { return }
        state.showVersionDialog = false
        uiState = .ready(state)
    }
}
