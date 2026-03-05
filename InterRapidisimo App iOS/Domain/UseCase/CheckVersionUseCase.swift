import Foundation

final class CheckVersionUseCase {
    private let versionRepository: VersionRepository

    init(versionRepository: VersionRepository) {
        self.versionRepository = versionRepository
    }

    func execute() async -> Result<VersionStatus, DomainError> {
        let result = await versionRepository.getRemoteVersion()
        switch result {
        case .success(let remoteString):
            let remoteVersion = Int(remoteString) ?? 0
            let localVersion = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0

            if localVersion == remoteVersion {
                return .success(.match(version: localVersion))
            } else if localVersion < remoteVersion {
                return .success(.localIsOutdated(local: localVersion, remote: remoteVersion))
            } else {
                return .success(.localIsNewer(local: localVersion, remote: remoteVersion))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
