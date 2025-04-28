
import SwiftUI

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


import FirebaseAuth
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var userUID: String?
    
    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.isAuthenticated = (user != nil)
            self?.userUID = user?.uid
        }
    }

    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}



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

struct ContentView: View {
    @StateObject var coordinator = Coordinator()
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var authViewModel2 = AuthViewModel2()

    var body: some View {
        Group {
            if let currentView = coordinator.currentView {
                currentView
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            checkAuthentication()
        }
        .onChange(of: authViewModel.isAuthenticated) { isAuthenticated in
                    if isAuthenticated {
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
        authViewModel2.checkAuthenticationStatus { uid in
            if let uid = uid {
                authViewModel.userUID = uid
                authViewModel.isAuthenticated = true
            } else {
                authViewModel.isAuthenticated = false
            }
        }
    }
}
