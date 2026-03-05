import Foundation

struct AuthRequestDTO: Encodable {
    let Mac: String
    let NomAplicacion: String
    let Password: String
    let Path: String
    let Usuario: String
}
