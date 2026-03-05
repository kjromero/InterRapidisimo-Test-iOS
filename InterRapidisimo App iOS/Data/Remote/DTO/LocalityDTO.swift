import Foundation

struct LocalityDTO: Decodable {
    let id: String?
    let typeId: String?
    let name: String?
    let shortName: String?
    let fullName: String?
    let cityAbbreviation: String?
    let parentName: String?
    let postalCode: String?
    let areaCode: String?
    let allowsPickup: Bool?
    let maxPickupTime: Int?
    let minPickupTime: Int?

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
