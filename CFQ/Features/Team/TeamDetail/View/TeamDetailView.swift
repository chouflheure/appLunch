import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = TeamFormViewModel()

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        if self.coordinator.teamDetail == nil {
            self.coordinator.showTeamDetail = false
        }
    }
    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showTeamDetail) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                coordinator.showTeamDetail = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()

                        Text(coordinator.teamDetail?.title ?? "Nop")
                            .foregroundColor(.white)
                            .tokenFont(.Title_Gigalypse_24)
                        
                        Spacer()

                        Button(action: {
                            withAnimation {
                                viewModel.showSheetSettingTeam = true
                            }
                        }) {
                            Image(.iconDots)
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 24)
                        }

                    }
                    .padding(.horizontal, 16)

                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            Button(action: {}) {
                                Image(.header)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                                    .frame(width: 90, height: 90)
                                    .clipShape(Circle())
                            }
                            .padding(.vertical, 16)
                            .padding(.bottom, 16)

                            HStack {
                                Button(action: {
                                    withAnimation {
                                        coordinator.showTeamDetail = false
                                        coordinator.selectedTab = 2
                                    }
                                }) {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    colors: [
                                                        Color(hex: "8A5BD0"),
                                                        Color(hex: "5E44A7"),
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 53, height: 53)
                                        Text("TURN")
                                            .tokenFont(.Label_Gigalypse_12)
                                    }
                                }
                            }
                            .padding(.bottom, 16)

                            Divider()
                                .overlay(.white)

                            ScrollView(.horizontal, showsIndicators: false) {
                                VStack(spacing: 0) {
                                    HStack(spacing: 0) {
                                        ForEach(coordinator.teamDetail?.friends ?? UserContact().userContactDefault(), id: \.self) { user in
                                            CellFriendAdmin (
                                                name: user.pseudo,
                                                isEditingAdmin: .constant(false),
                                                isAdmin: Binding(
                                                    get: {
                                                        coordinator.teamDetail?.admins.contains(user) ?? false
                                                    },
                                                    set: { newValue in
                                                        if newValue {
                                                            coordinator.teamDetail?.admins.append(user)
                                                        } else {
                                                            coordinator.teamDetail?.admins.remove(at: 0)

                                                        }
                                                    }
                                                )
                                            ).padding(.trailing, 12)
                                        }
                                        .frame(height: 110)
                                    }
                                }
                            }
                            .padding(.top, 10)

                            if viewModel.isAdminEditing {
                                Button(action: {
                                    withAnimation {
                                        viewModel.isAdminEditing = false
                                    }
                                }) {
                                    Text("Done")
                                        .tokenFont(.Body_Inter_Regular_16)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 30)
                                        .padding(.vertical, 10)
                                        .background(.black)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay() {
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(.white)
                                        }
                                }
                            } else {
                                Divider()
                                    .overlay(.whitePrimary)
                                
                                CFQCollectionView(coordinator: coordinator)
                                    .padding(.vertical, 10)
                                
                                Divider()
                                    .overlay(.whiteSecondary)
                            }
                        }

                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showSheetSettingTeam) {
            SettingsTeamDetailSheet(
                coordinator: coordinator,
                isAdmin: $viewModel.isUserAdmin// ,
                // viewModel: viewModel
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
                
        }
    }
}
