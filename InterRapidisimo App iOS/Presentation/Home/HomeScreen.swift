import SwiftUI

struct HomeScreen: View {
    @Bindable var viewModel: HomeViewModel
    var onNavigateToTables: () -> Void
    var onNavigateToLocalities: () -> Void

    var body: some View {
        ZStack {
            Color.interBackground
                .ignoresSafeArea()

            switch viewModel.uiState {
            case .loading:
                ProgressView()
                    .tint(.interBlack)

            case .ready(let user):
                VStack(spacing: 0) {
                    // Header
                    ZStack {
                        Color.interBlack
                        VStack(spacing: 4) {
                            Image("Icon_app")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 70, height: 70)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            Text("Bienvenido")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                        }
                        .padding(.vertical, 24)
                    }
                    .frame(height: 150)

                    ScrollView {
                        VStack(spacing: 20) {
                            // User info card
                            VStack(alignment: .leading, spacing: 12) {
                                userInfoRow(label: "Usuario", value: user.username)
                                Divider()
                                    .background(Color.interYellow)
                                    .frame(height: 2)
                                userInfoRow(label: "Identificación", value: user.identification)
                                Divider()
                                    .background(Color.interYellow)
                                    .frame(height: 2)
                                userInfoRow(label: "Nombre", value: user.name)
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                            .padding(.horizontal)

                            // Navigation buttons
                            VStack(spacing: 12) {
                                Button {
                                    onNavigateToTables()
                                } label: {
                                    HStack {
                                        Image(systemName: "tablecells")
                                        Text("Tablas")
                                            .font(.headline)
                                    }
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.interBlack)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }

                                Button {
                                    onNavigateToLocalities()
                                } label: {
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                        Text("Localidades")
                                            .font(.headline)
                                    }
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.interRed)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.top, 24)
                    }
                }

            case .error:
                ErrorMessageView(message: "No se pudo cargar la información del usuario.")
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadUser()
        }
    }

    private func userInfoRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body.bold())
                .foregroundStyle(.primary)
        }
    }
}
