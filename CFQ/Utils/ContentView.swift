
import SwiftUI
import FirebaseAuth

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

