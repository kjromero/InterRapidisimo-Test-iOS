import SwiftUI

enum AppRoute: Hashable {
    case home
    case tables
    case localities
}

struct ContentView: View {
    @State private var navigationPath = NavigationPath()
    @State private var isLoggedIn = false

    private let container = DependencyContainer.shared

    var body: some View {
        if !isLoggedIn {
            LoginScreen(
                viewModel: container.makeLoginViewModel(),
                onNavigateToHome: {
                    isLoggedIn = true
                }
            )
        } else {
            NavigationStack(path: $navigationPath) {
                HomeScreen(
                    viewModel: container.makeHomeViewModel(),
                    onNavigateToTables: {
                        navigationPath.append(AppRoute.tables)
                    },
                    onNavigateToLocalities: {
                        navigationPath.append(AppRoute.localities)
                    }
                )
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .home:
                        HomeScreen(
                            viewModel: container.makeHomeViewModel(),
                            onNavigateToTables: {
                                navigationPath.append(AppRoute.tables)
                            },
                            onNavigateToLocalities: {
                                navigationPath.append(AppRoute.localities)
                            }
                        )
                    case .tables:
                        TablasScreen(viewModel: container.makeTablasViewModel())
                    case .localities:
                        LocalidadesScreen(viewModel: container.makeLocalitiesViewModel())
                    }
                }
            }
            .tint(.interBlack)
        }
    }
}


