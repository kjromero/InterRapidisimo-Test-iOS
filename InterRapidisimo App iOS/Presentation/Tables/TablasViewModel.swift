import Foundation

enum TablesUiState {
    case loading
    case success([Table])
    case error(DomainError)
}

@Observable
final class TablasViewModel {
    var uiState: TablesUiState = .loading

    private let syncTablesUseCase: SyncTablesUseCase
    private let getTablesUseCase: GetTablesUseCase

    init(syncTablesUseCase: SyncTablesUseCase, getTablesUseCase: GetTablesUseCase) {
        self.syncTablesUseCase = syncTablesUseCase
        self.getTablesUseCase = getTablesUseCase
    }

    func loadTables() async {
        uiState = .loading
        let syncResult = await syncTablesUseCase.execute()

        switch syncResult {
        case .success:
            let tables = await getTablesUseCase.execute()
            uiState = .success(tables)
        case .failure(let error):
            uiState = .error(error)
        }
    }
}
