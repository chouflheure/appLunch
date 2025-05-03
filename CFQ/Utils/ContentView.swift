
import SwiftUI
import FirebaseAuth
import Combine
import Lottie

enum StatusConnexion {
    case wait
    case connecte
    case noConnecte
}

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: StatusConnexion = .wait
    @Published var userUID: String?
    
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = (user != nil) ? .connecte : .noConnecte
            self?.userUID = user?.uid
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(Auth.auth().currentUser?.uid)
        } else {
            completion(nil)
        }
    }
}

struct ContentView: View {
    @StateObject var coordinator = Coordinator()
    @ObservedObject private var authViewModel = AuthViewModel()
    @State var isFinishToLoad: Bool = true

    var body: some View {
        Group {
            if let currentView = coordinator.currentView {
                currentView
            } else {
                LoadingFirstView(isFinishToLoad: $isFinishToLoad)
            }
        }
        .onAppear {
            checkAuthentication()
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
            if authViewModel.isAuthenticated == .connecte {
                coordinator.start(userUID: authViewModel.userUID)
            } else {
                coordinator.currentView = AnyView(
                    NavigationView {
                        SignScreen(coordinator: coordinator)
                    }
                )
            }
        }
    }
    
    private func checkAuthentication() {
        authViewModel.checkAuthenticationStatus { uid in
            if let uid = uid {
                authViewModel.userUID = uid
                authViewModel.isAuthenticated = .connecte
            } else {
                authViewModel.isAuthenticated = .noConnecte
            }
        }
    }
}


struct LoadingFirst: View {

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                
                
                LottieView(
                    animation: .named(
                        StringsToken.Animation.loaderCircle
                    )
                )
                .playing()
                .looping()
                .frame(width: 150, height: 150)
            }
        }

    }
}

struct LoadingFirstView: View {
    @Binding var isFinishToLoad: Bool

    var body: some View {
        ZStack {
            NeonBackgroundImage()
            VStack {
                Spacer() // Pousse le contenu vers le bas
                Image(.whiteLogo)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal, 25)
                Spacer() // Pousse le contenu vers le haut
/*
                LottieView(
                    animation: .named(
                        StringsToken.Animation.loaderCircle
                    )
                )
                .playing()
                .looping()
                .frame(width: 150, height: 150)
 */
            }
        }

    }
}


#Preview {
    LoadingFirstView(isFinishToLoad: .constant(true))
}
