import Foundation

final class GetStoredUserUseCase {
    private let authRepository: AuthRepository

    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }

    func execute() async -> User? {
        await authRepository.getStoredUser()
    }
}
