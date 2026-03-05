import Foundation

struct LocalityDTO: Decodable {
    let id: Int?
    let typeId: Int?
    let name: String?
    let shortName: String?
    let fullName: String?
    let cityAbbreviation: String?
    let parentName: String?
    let postalCode: String?
    let areaCode: String?
    let allowsPickup: Bool?
    let maxPickupTime: String?
    let minPickupTime: String?

    enum CodingKeys: String, CodingKey {
        case id = "IdLocalidad"
        case typeId = "IdTipoLocalidad"
        case name = "Nombre"
        case shortName = "NombreCorto"
        case fullName = "NombreCompleto"
        case cityAbbreviation = "AbreviacionCiudad"
        case parentName = "NombreAncestroPGrado"
        case postalCode = "CodigoPostal"
        case areaCode = "Indicativo"
        case allowsPickup = "PermiteRecogida"
        case maxPickupTime = "HoraMaxRecogida"
        case minPickupTime = "HoraMinRecogida"
    }
}
