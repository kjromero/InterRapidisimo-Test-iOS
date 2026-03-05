import Foundation

extension DomainError {
    var uiMessage: String {
        switch self {
        case .network:       return "Sin conexión. Verifica tu red e intenta de nuevo."
        case .unauthorized:  return "Credenciales incorrectas."
        case .server:        return "Error en el servidor. Intenta más tarde."
        case .unknown:       return "Ocurrió un error inesperado."
        }
    }
}
