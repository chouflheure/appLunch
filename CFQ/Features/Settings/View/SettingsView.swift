
import SwiftUI
import PhotosUI
import MessageUI
import StoreKit

class ScreenSettingsData {
    var icon: ImageResource
    var label: String
    var screen: ScreensSettingsType
    var color: Color?
    
    init(icon: ImageResource, label: String, screen: ScreensSettingsType, color: Color = .white) {
        self.icon = icon
        self.label = label
        self.screen = screen
        self.color = color
    }
}

struct SettingsView: View {
    @State private var showDetail = false
    @State private var selectedDestination: ScreensSettingsType? = nil
    @State private var showPopup = false
    
    @EnvironmentObject var user: User
    @Environment(\.requestReview) var requestReview
    @Environment(\.dismiss) var dismiss

    var coordinator: Coordinator

    var arrayIconTitleForNextScreen: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconNavProfile,
            label: StringsToken.Settings.headereditMyProfil,
            screen: .editProfile
        ),

        ScreenSettingsData(
            icon: .iconPlus,
            label: StringsToken.Settings.onboardingPreview,
            screen: .onboarding
        ),

        ScreenSettingsData(
            icon: .iconBug,
            label: StringsToken.Settings.aBugTellUs,
            screen: .bugReport
        ),

        ScreenSettingsData(
            icon: .iconNotifs,
            label: StringsToken.Settings.notifications,
            screen: .notifications
        )
    ]
    
    var arrayIconTitleForPopUp: [ScreenSettingsData] = [
        ScreenSettingsData(
            icon: .iconDoor,
            label: StringsToken.Settings.logOut,
            screen: .logout,
            color: .purpleDark
        ),
        ScreenSettingsData(
            icon: .iconCross,
            label: StringsToken.Settings.deleteAccount,
            screen: .removeAccount,
            color: .red
        ),
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

                    ForEach(arrayIconTitleForNextScreen, id: \.icon) { data in
                        SettingCellView(
                            data: data,
                            onClick: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showDetail = true
                                    selectedDestination = data.screen
                                }
                            }
                        )
                        .padding(12)
                    }
                    
                    SettingCellView(
                        data: ScreenSettingsData(
                            icon: .iconStar,
                            label: StringsToken.Settings.noteTheApp,
                            screen: .notifications
                        ),
                        onClick: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                requestReview()
                            }
                        }
                    )
                    .padding(12)
                    
                    ForEach(arrayIconTitleForPopUp, id: \.icon) { data in
                        SettingCellView(
                            data: data,
                            onClick: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    showPopup = true
                                    selectedDestination = data.screen
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
                EditProfileUserView(showDetail: $showDetail, user: user)
            case .onboarding:
                OnboardingPreviewSettingsView(showDetail: $showDetail)
            case .bugReport:
                IssueReportView(showDetail: $showDetail)
            case .notifications:
                NotificationsListView(showDetail: $showDetail)
            case .logout:
                PopUpSettings(showPopup: $showPopup, popupType: .logout, coordinator: coordinator)
            case .removeAccount:
                PopUpSettings(showPopup: $showPopup, popupType: .removeProfile, coordinator: coordinator)
            }
        }
}

private struct SettingCellView: View {
    var data: ScreenSettingsData
    var onClick: (() -> Void)
    
    var body: some View {
        HStack{
            Button(action: {onClick()}, label: {
                Image(data.icon)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 20, height: 20)
                    .foregroundColor(data.color)

                Text(data.label)
                    .tokenFont(.Body_Inter_Medium_14, color: data.color)
                Spacer()
            })
        }
    }
}

#Preview {
    SettingsView(coordinator: .init())
}
