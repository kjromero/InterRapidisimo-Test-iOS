import SwiftUI

struct LocalidadesScreen: View {
    @Bindable var viewModel: LocalitiesViewModel

    var body: some View {
        ZStack {
            Color.interBackground
                .ignoresSafeArea()

            switch viewModel.uiState {
            case .loading:
                ProgressView("Cargando localidades...")
                    .tint(.interBlack)

            case .success(let localities):
                List(localities, id: \.cityAbbreviation) { locality in
                    localityRow(locality)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

            case .error(let error):
                ErrorMessageView(message: error.uiMessage)
            }
        }
        .navigationTitle("Localidades")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadLocalities()
        }
    }

    private func localityRow(_ locality: Locality) -> some View {
        HStack(spacing: 12) {
            Text(locality.cityAbbreviation)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.interBlack)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(locality.fullName)
                .font(.subheadline)
                .foregroundStyle(.primary)

            Spacer()
        }
        .padding(12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}
