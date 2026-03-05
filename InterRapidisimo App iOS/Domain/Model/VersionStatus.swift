import Foundation

enum VersionStatus {
    case match(version: Int)
    case localIsOutdated(local: Int, remote: Int)
    case localIsNewer(local: Int, remote: Int)
}
