/*

import SwiftUI

struct ContentView: View {
    var body: some View {
        SignScreen()
    }
}

#Preview {
    SignScreen()
}

*/
 import SwiftUI

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

