import Foundation

protocol HttpErrorMapper {
    func map(statusCode: Int) -> DomainError
}

final class DefaultHttpErrorMapper: HttpErrorMapper {
    func map(statusCode: Int) -> DomainError {
        switch statusCode {
        case 401, 403: return .unauthorized
        case 500...599: return .server
        default:        return .unknown
        }
    }
}
