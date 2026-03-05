import Foundation

final class InterAPIClient {
    private let session: URLSession
    private let errorMapper: HttpErrorMapper

    init(session: URLSession = .shared, errorMapper: HttpErrorMapper = DefaultHttpErrorMapper()) {
        self.session = session
        self.errorMapper = errorMapper
    }

    // MARK: - Version Control

    func getVersionControl() async -> Result<String, DomainError> {
        let urlString = "\(AppConfig.baseURL)/apicontrollerpruebas/api/ParametrosFramework/ConsultarParametrosFramework/VPStoreAppControl"
        guard let url = URL(string: urlString) else {
            return .failure(.unknown)
        }

        do {
            let (data, response) = try await session.data(from: url)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(errorMapper.map(statusCode: httpResponse.statusCode))
            }
            let raw = String(data: data, encoding: .utf8) ?? "0"
            let version = raw.trimmingCharacters(in: CharacterSet(charactersIn: "\"").union(.whitespacesAndNewlines))
            return .success(version)
        } catch is URLError {
            return .failure(.network)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - Schema / Tables

    func getSchema() async -> Result<[TableSchemeDTO], DomainError> {
        let urlString = "\(AppConfig.baseURL)/apicontrollerpruebas/api/SincronizadorDatos/ObtenerEsquema/true"
        guard let url = URL(string: urlString) else {
            return .failure(.unknown)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("usuario", forHTTPHeaderField: "usuario")

        do {
            let (data, response) = try await session.data(for: request)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(errorMapper.map(statusCode: httpResponse.statusCode))
            }
            let tables = try JSONDecoder().decode([TableSchemeDTO].self, from: data)
            return .success(tables)
        } catch is URLError {
            return .failure(.network)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - Localities

    func getPickupLocations() async -> Result<[LocalityDTO], DomainError> {
        let urlString = "\(AppConfig.baseURL)/apicontrollerpruebas/api/ParametrosFramework/ObtenerLocalidadesRecogidas"
        guard let url = URL(string: urlString) else {
            return .failure(.unknown)
        }

        do {
            let (data, response) = try await session.data(from: url)
            print("RESPONSE:", response)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(errorMapper.map(statusCode: httpResponse.statusCode))
            }
            print("LOCALITIES RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
            let localities = try JSONDecoder().decode([LocalityDTO].self, from: data)
            return .success(localities)
        } catch is URLError {
            return .failure(.network)
        } catch {
            return .failure(.unknown)
        }
    }

    // MARK: - Authentication

    func authenticate() async -> Result<AuthResponseDTO, DomainError> {
        let urlString = "\(AppConfig.baseURL)/FtEntregaElectronica/MultiCanales/ApiSeguridadPruebas/api/Seguridad/AuthenticaUsuarioApp"
        guard let url = URL(string: urlString) else {
            return .failure(.unknown)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("pam.meredy21", forHTTPHeaderField: "Usuario")
        request.setValue("987204545", forHTTPHeaderField: "Identificacion")
        request.setValue("text/json", forHTTPHeaderField: "Accept")
        request.setValue("pam.meredy21", forHTTPHeaderField: "IdUsuario")
        request.setValue("1295", forHTTPHeaderField: "IdCentroServicio")
        request.setValue("PTO/BOGOTA/CUND/COL/OF PRINCIPAL - CRA 30 # 7-45", forHTTPHeaderField: "NombreCentroServicio")
        request.setValue("9", forHTTPHeaderField: "IdAplicativoOrigen")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        let body = AuthRequestDTO(
            Mac: "",
            NomAplicacion: "Controller APP",
            Password: "SW50ZXIyMDIx\n",
            Path: "",
            Usuario: "cGFtLm1lcmVkeTIx\n"
        )
        request.httpBody = try? JSONEncoder().encode(body)
        print("URL:", request.url ?? "")
        print("METHOD:", request.httpMethod ?? "")
        print("HEADERS:", request.allHTTPHeaderFields ?? "")

        if let body = request.httpBody {
            print("BODY:", String(data: body, encoding: .utf8) ?? "")
        }
        do {
            let (data, response) = try await session.data(for: request)
            print("RESPONSE:", response)
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                return .failure(errorMapper.map(statusCode: httpResponse.statusCode))
            }
            print("AUTH RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "nil")
            let dto = try JSONDecoder().decode(AuthResponseDTO.self, from: data)
            return .success(dto)
        } catch is URLError {
            return .failure(.network)
        } catch {
            print("AUTH DECODE ERROR:", error)
            return .failure(.unknown)
        }
    }
}
