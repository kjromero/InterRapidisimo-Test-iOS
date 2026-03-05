import SwiftUI

struct LoginScreen: View {
    @Bindable var viewModel: LoginViewModel
    var onNavigateToHome: () -> Void

    var body: some View {
        ZStack {
            Color.interBackground
                .ignoresSafeArea()

            switch viewModel.uiState {
            case .initializing:
                VStack {
                    headerView
                    Spacer()
                    ProgressView("Inicializando...")
                        .tint(.interBlue)
                    Spacer()
                }

            case .ready(let state):
                VStack(spacing: 0) {
                    headerView

                    ScrollView {
                        VStack(spacing: 20) {
                            if let versionStatus = state.versionStatus {
                                versionCard(status: versionStatus)
                            }

                            Button {
                                Task {
                                    await viewModel.login()
                                }
                            } label: {
                                Text("Iniciar Sesión")
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.interBlue)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding(.horizontal)
                            .disabled(state.isLoginLoading)
                        }
                        .padding(.top, 24)
                    }
                }
                .alert("Versión", isPresented: Binding(
                    get: { state.showVersionDialog },
                    set: { _ in viewModel.dismissVersionDialog() }
                )) {
                    Button("Aceptar", role: .cancel) {
                        viewModel.dismissVersionDialog()
                    }
                } message: {
                    if let status = state.versionStatus {
                        Text(versionMessage(for: status))
                    }
                }
                .alert("Error", isPresented: Binding(
                    get: { state.error != nil },
                    set: { _ in viewModel.dismissError() }
                )) {
                    Button("Aceptar", role: .cancel) {
                        viewModel.dismissError()
                    }
                } message: {
                    if let error = state.error {
                        Text(error.uiMessage)
                    }
                }

                if state.isLoginLoading {
                    LoadingOverlay()
                }
            }
        }
        .task {
            await viewModel.initialize()
        }
        .onChange(of: viewModel.navigationEvent) { _, newValue in
            if case .navigateToHome = newValue {
                viewModel.navigationEvent = nil
                onNavigateToHome()
            }
        }
    }

    // MARK: - Header

    private var headerView: some View {
        ZStack {
            Color.interBlue
            VStack(spacing: 8) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
                Text("InterRapidísimo")
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }
            .padding(.vertical, 32)
        }
        .frame(height: 180)
    }

    // MARK: - Version Card

    @ViewBuilder
    private func versionCard(status: VersionStatus) -> some View {
        let (color, icon, text) = versionInfo(for: status)

        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .font(.title2)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.primary)
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private func versionInfo(for status: VersionStatus) -> (Color, String, String) {
        switch status {
        case .match(let version):
            return (.green, "checkmark.circle.fill", "Versión actualizada (v\(version))")
        case .localIsOutdated(let local, let remote):
            return (.orange, "exclamationmark.triangle.fill", "Actualización disponible (v\(local) → v\(remote))")
        case .localIsNewer(let local, let remote):
            return (.blue, "info.circle.fill", "Versión de desarrollo (v\(local), remota: v\(remote))")
        }
    }

    private func versionMessage(for status: VersionStatus) -> String {
        switch status {
        case .match(let version):
            return "Tu versión (v\(version)) está actualizada."
        case .localIsOutdated(let local, let remote):
            return "Tu versión local (v\(local)) está desactualizada. La versión remota es v\(remote)."
        case .localIsNewer(let local, let remote):
            return "Tu versión local (v\(local)) es más reciente que la remota (v\(remote))."
        }
    }
}
