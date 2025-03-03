
import SwiftUI
import PhotosUI
import MessageUI

struct SettingsView: View {
    @State private var showDetail = false
    @State private var selectedDestination: ScreensSettingsType? = nil
    @State private var showPopup = false
    var firebase = FirebaseService()
    var viewModel = SettingsViewModel()
    var coordinator: Coordinator
    @Environment(\.dismiss) var dismiss

    var arrayIconTitleForNextScreen: [(icon: ImageResource, value: String, screen: ScreensSettingsType)] = [
        (.iconNavProfile, StringsToken.Settings.headereditMyProfil, .editProfile),
        (.iconPlus, StringsToken.Settings.onboardingPreview, .onboarding),
        (.iconNotifs, StringsToken.Settings.aBugTellUs, .bugReport)
    ]
    
    var arrayIconTitleForPopUp: [(icon: ImageResource, value: String, screen: ScreensSettingsType)] =
    [
        (.iconDoor, StringsToken.Settings.logOut, .logout),
        (.iconCross, StringsToken.Settings.deleteAccount, .removeAccount)
    ]

    var body: some View {
        ZStack {
            Color.black
            VStack {
                HStack(alignment: .center) {

                    Text("Paramètres")
                        .tokenFont(.Title_Inter_semibold_24)
                        .textCase(.uppercase)

                    Spacer()
                    
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(.iconArrow)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white)
                                .rotationEffect(Angle(degrees: -90))
                        }
                    )
                }
                .padding(.horizontal, 16)
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
                EditProfileUserView(showDetail: $showDetail, viewModel: viewModel)
            case .onboarding:
                OnboardingPreviewSettingsView(showDetail: $showDetail)
            case .bugReport:
                IssueReportView(showDetail: $showDetail)
            case .logout:
                PopUpSettings(showPopup: $showPopup, popupType: .logout, coordinator: coordinator)
            case .removeAccount:
                PopUpSettings(showPopup: $showPopup, popupType: .removeProfile, coordinator: coordinator)
            }
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
        }
    }
}

#Preview {
    SettingsView(coordinator: .init())
}
