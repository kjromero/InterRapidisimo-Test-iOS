import Foundation

struct AuthResponseDTO: Decodable {
    let username: String?
    let identification: String?
    let name: String?
    let lastName1: String?
    let lastName2: String?
    let position: String?
    let applications: String?
    let locations: String?
    let resultCode: String?
    let localityId: String?
    let localityName: String?
    let roleName: String?
    let roleId: String?
    let tokenJwt: String?
    let appModules: String?

    enum CodingKeys: String, CodingKey {
        case username = "Usuario"
        case identification = "Identificacion"
        case name = "Nombre"
        case lastName1 = "Apellido1"
        case lastName2 = "Apellido2"
        case position = "Cargo"
        case applications = "Aplicaciones"
        case locations = "Ubicaciones"
        case resultCode = "MensajeResultado"
        case localityId = "IdLocalidad"
        case localityName = "NombreLocalidad"
        case roleName = "NomRol"
        case roleId = "IdRol"
        case tokenJwt = "TokenJWT"
        case appModules = "ModulosApp"
    }
}
