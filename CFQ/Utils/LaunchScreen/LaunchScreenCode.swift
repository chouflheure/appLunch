import SwiftUI

struct LaunchScreenViewAnimation: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 1.0

    var body: some View {
        SafeAreaContainer {
            if isActive {
                ContentView()
            } else {
                VStack {
                    VStack {
                        Image(.blackLogo) // Remplacez par votre image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.size = 1.9
                            self.opacity = 1.0
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue) // Couleur de fond de l'écran de lancement
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}
