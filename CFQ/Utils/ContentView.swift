
import SwiftUI
import FirebaseAuth
import Combine

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
    // @ObservedObject private var authViewModel2 = AuthViewModel2()

    var body: some View {
        Group {
            if let currentView = coordinator.currentView {
                currentView
            } else {
                LoadingFirstView()
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

struct LoadingFirstView: View {
    var body: some View {
        SafeAreaContainer {
            Text("Loading... Test")
                .foregroundColor(.white)
        }
    }
}

/*
class AuthViewModel2: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userUID: String?

    func checkAuthenticationStatus(completion: @escaping (String?) -> Void) {
        if Auth.auth().currentUser != nil {
            completion(Auth.auth().currentUser?.uid)
        } else {
            completion(nil)
        }
    }
}
 */


/*
struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            
            if authViewModel.isAuthenticated {
                Text("Auth")
            } else {
                Text("No auth")
            }
        }
        .onAppear {
            authViewModel.isAuthenticated = (Auth.auth().currentUser != nil)
            print("@@@ authViewModel.isAuthenticated = \(authViewModel.isAuthenticated)")
        }
    }
}
*/

/*
struct ContentView: View {
    @StateObject var coordinator = Coordinator()
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if let currentView = coordinator.currentView {
                currentView
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            coordinator.start()
        }
    }
}

#Preview {
    ContentView()
}
*/
