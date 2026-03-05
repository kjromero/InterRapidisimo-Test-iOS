import Foundation

protocol AuthRepository {
    func login() async -> Result<User, DomainError>
    func getStoredUser() async -> User?
}
