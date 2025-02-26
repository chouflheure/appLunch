
import SwiftUI

struct SettingsView: View {
    @State private var showDetail = false
    @State private var selectedDestination: ScreensSettingsType? = nil
    @State private var showPopup = false

    var arrayIconTitleForNextScreen: [(icon: ImageResource, value: String, screen: ScreensSettingsType)] = [
        (.iconNavProfile, "Modifier mon profil", .editProfile),
        (.iconPlus, "Guide d'utilisation", .onboarding),
        (.iconNotifs, "Un bug, une remarque ? Dis nous tout !", .bugReport)
    ]
    
    var arrayIconTitleForPopUp: [(icon: ImageResource, value: String, screen: ScreensSettingsType)] =
    [
        (.iconDoor, "Se deconnecter", .logout),
        (.iconCross, "Supprimer mon compte", .removeAccount)
    ]
    
    var coordinator: Coordinator

    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack(alignment: .center) {
                    Button(
                        action: {},
                        label: {
                            Image(.iconArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    )

                    Text("Paramètres")
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)

                    Spacer()
                }
                .background(.black)
                
                Divider()
                    .background(.white)
                
                VStack(alignment: .leading) {
                    
                    ForEach(arrayIconTitleForNextScreen, id: \.icon) { info in
                        SettingCellView(
                            icon: info.icon,
                            label: info.value,
                            onClick: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showDetail = true
                                    selectedDestination = info.screen
                                }
                            }
                        )
                        .padding(12)
                    }
                    
                    ForEach(arrayIconTitleForPopUp, id: \.icon) { info in
                        SettingCellView(
                            icon: info.icon,
                            label: info.value,
                            onClick: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showPopup = true
                                    selectedDestination = info.screen
                                }
                            }
                        )
                        .padding(12)
                    }
                }
                Spacer()
            }
            .padding(.top, 50)
            .blur(radius: showPopup ? 10 : 0) // Flou lorsque la popup est ouverte
            .allowsHitTesting(!showPopup)
            
            if showPopup, let screen = selectedDestination {
                Color.black.opacity(0.4) // FOND CLIQUABLE
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showPopup = false
                        }
                    }
                    .zIndex(1) // MOINS PRIORITAIRE QUE LA POPUP

                destinationView(for: screen)
                    .zIndex(2)
            }
            
            if showDetail, let screen = selectedDestination {
                destinationView(for: screen)
                    .transition(.move(edge: .trailing))
                    .zIndex(1)
            }
        }.ignoresSafeArea()
    }
    
    @ViewBuilder
        private func destinationView(for screen: ScreensSettingsType) -> some View {
            switch screen {
            case .editProfile:
                DetailView(showDetail: $showDetail)
            case .onboarding:
                OnboardingPreviewSettings(showDetail: $showDetail)
            case .bugReport:
                OnboardingPreviewSettings(showDetail: $showDetail)
            case .logout:
                PopupLogOutUser(showPopup: $showPopup)
            case .removeAccount:
                PopUpRemoveProfile(showPopup: $showPopup)
            }
        }
}



struct PopupLogOutUser: View {
    @Binding var showPopup: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(.imageSuspicious)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70)

                Text("Tu te veux te déconnecter ?")
                
                HStack {
                    Button("Nop, je reste") {
                        withAnimation {
                            showPopup = false
                        }
                    }
                    Spacer()
                    Button("Chao !") {
                        withAnimation {
                            showPopup = false
                        }
                    }
                }
            }
            .padding()
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .zIndex(2) // Assure que la popup est au-dessus
        }
    }
}

#Preview {
    @State var showPopup = true

    ZStack {
        Color.black
        PopupLogOutUser(showPopup: $showPopup)
    }
}

struct PopUpRemoveProfile: View {
    @Binding var showPopup: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Ceci est une popup")
                    .font(.title)
                
                Button("Fermer") {
                    withAnimation {
                        showPopup = false
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .zIndex(2) // Assure que la popup est au-dessus
        }
    }
}

enum ScreensSettingsType {
    case editProfile
    case onboarding
    case bugReport
    case logout
    case removeAccount
}

private struct PopUpLogOut: View {
    var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Vous êtes bien déconnecté")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding()
            
            Button("Fermer") {
                coordinator.logOutUser()
            }
        }
        .frame(width: 200, height: 400)
        .background(.white)
    }
}


private struct OnboardingPreviewSettings: View {
    @Binding var showDetail: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            OnboardingView(onFinish: close)
        }
    }

    func close() {
        withAnimation {
            showDetail = false
        }
    }
}

struct DetailView: View {
    @Binding var showDetail: Bool
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack {
                Text("Vue Détail")
                    .font(.largeTitle)
                    .padding()
                
                Button("Fermer") {
                    withAnimation {
                        showDetail = false
                    }
                }
                .padding()
            }
        }
        .offset(x: dragOffset) // Bouge la vue avec le drag
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.width > 0 { // Seulement vers la droite
                        dragOffset = value.translation.width
                    }
                }
                .onEnded { value in
                    if value.translation.width > 150 { // Si glissé assez loin, fermer
                        withAnimation {
                            showDetail = false
                        }
                    } else {
                        withAnimation {
                            dragOffset = 0 // Revenir à sa place
                        }
                    }
                }
        )
    }
}

private struct SettingCellView: View {
    var icon: ImageResource
    var label: String
    var onClick: (() -> Void)
    
    var body: some View {
        HStack{
            Button(action: {onClick()}, label: {
                Image(icon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                
                Text(label)
                    .tokenFont(.Body_Inter_Medium_14)

                Spacer()
            })
            .frame(width: .infinity)
        }
    }
}

#Preview {
    SettingsView(coordinator: .init())
}
