
import SwiftUI
import FirebaseAuth


// TODO: Add this method to check if user is connected

class AuthViewModel: ObservableObject {
    @Published var isUserLoggedIn: Bool = false
//     @Published var user: User?

    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                self.isUserLoggedIn = true
                // self.user = user
                print("Utilisateur connecté :", user.uid)
            } else {
                self.isUserLoggedIn = false
                // self.user = nil
                print("Aucun utilisateur connecté.")
            }
        }
    }
}


 struct ContentView: View {
     @StateObject var coordinator = Coordinator()

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

