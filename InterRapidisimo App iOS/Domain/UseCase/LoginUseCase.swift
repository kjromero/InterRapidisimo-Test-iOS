import Foundation

final class LoginUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async -> Result<User, DomainError> {
        await authRepository.login()
    }
}
