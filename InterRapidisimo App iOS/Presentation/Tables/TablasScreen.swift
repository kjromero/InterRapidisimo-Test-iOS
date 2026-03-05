import SwiftUI

struct TablasScreen: View {
    @Bindable var viewModel: TablasViewModel

    var body: some View {
        ZStack {
            Color.interBackground
                .ignoresSafeArea()

            switch viewModel.uiState {
            case .loading:
                ProgressView("Sincronizando tablas...")
                    .tint(.interBlue)

            case .success(let tables):
                List(tables, id: \.tableName) { table in
                    tableRow(table)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

            case .error(let error):
                ErrorMessageView(message: error.uiMessage)
            }
        }
        .navigationTitle("Tablas")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadTables()
        }
    }

    private func tableRow(_ table: Table) -> some View {
        HStack(spacing: 0) {
            // Blue left accent
            Color.interBlue
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 6) {
                Text(table.tableName)
                    .font(.subheadline.bold())
                    .foregroundStyle(.primary)

                HStack(spacing: 16) {
                    if let pk = table.primaryKey {
                        Label("PK: \(pk)", systemImage: "key.fill")
                            .font(.caption)
                            .foregroundStyle(Color.interBlue)
                    }
                    if let fields = table.fieldCount {
                        Label("Campos: \(fields)", systemImage: "number")
                            .font(.caption)
                            .foregroundStyle(Color.interBlue)
                    }
                }

                if let syncDate = table.lastSyncDate {
                    Text(syncDate)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
