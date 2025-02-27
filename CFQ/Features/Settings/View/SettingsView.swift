
import SwiftUI

struct SettingsView: View {
    @State private var showDetail = false
    @State private var selectedDestination: ScreensSettingsType? = nil
    @State private var showPopup = false
    var firebase = FirebaseService()
    
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
            .blur(radius: showPopup ? 10 : 0)
            .allowsHitTesting(!showPopup)
            
            // FOND CLIQUABLE
            if showPopup, let screen = selectedDestination {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showPopup = false
                        }
                    }
                    .zIndex(1)

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
                EditProfileUser(showDetail: $showDetail)
            case .onboarding:
                OnboardingPreviewSettings(showDetail: $showDetail)
            case .bugReport:
                OnboardingPreviewSettings(showDetail: $showDetail)
            case .logout:
                PopUpSettings(showPopup: $showPopup, popupType: .logout)
            case .removeAccount:
                PopUpSettings(showPopup: $showPopup, popupType: .removeProfile)
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

private struct EditProfileUser: View {
    @Binding var showDetail: Bool
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack(alignment: .center, spacing: 30) {
                    Button(
                        action: {},
                        label: {
                            Image(.iconArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                        }
                    )

                    Text("Mon Profil")
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)

                    Spacer()
                    
                }
                .background(.black)
                .padding(.leading, 20)
                
                Divider()
                    .background(.white)
                
                Spacer()
                
                
            }
            .padding(.top, 50)
            
        }.ignoresSafeArea()
        
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

#Preview {
    @State var isPresented: Bool = true
    EditProfileUser(showDetail: $isPresented)
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
        }
    }
}

#Preview {
    SettingsView(coordinator: .init())
}
