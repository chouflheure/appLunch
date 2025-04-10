import SwiftUI

struct TeamDetailView: View {
    @Binding var show: Bool
    @ObservedObject var coordinator: Coordinator

    var title = "GIRLS ONLY"
    @StateObject var viewModel = TeamFormViewModel()
    var edit = false

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

    var body: some View {
        DraggableView(isPresented: $show) {
            SafeAreaContainer {
                VStack {
                    HStack {
                        Button(action: {
                            withAnimation {
                                show = false
                            }
                        }) {
                            Image(.iconArrow)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                        }
                        
                        Spacer()
                        
                        Text(title)
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
                                        show = false
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
                                        ForEach(Array(viewModel.friendsAdd), id: \.self) { user in
                                            CellFriendAdmin (
                                                name: user.name,
                                                isEditingAdmin: $viewModel.isAdminEditing,
                                                isAdmin: Binding(
                                                            get: {
                                                                viewModel.adminList.contains(user)
                                                            },
                                                            set: { newValue in
                                                                if newValue {
                                                                    viewModel.adminList.insert(user)
                                                                } else {
                                                                    viewModel.adminList.remove(user)
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
                                
                                CFQCollectionView()
                                    .padding(.vertical, 10)
                                
                                Divider()
                                    .overlay(.whiteSecondary)
                            }
                        }

                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.showEditTeam) {
            TeamFormView(showDetail: $viewModel.showEditTeam, viewModel: viewModel)
        }

        .fullScreenCover(isPresented: $viewModel.showFriendsList) {
            ListFriendToAdd(
                showDetail: $viewModel.showFriendsList,
                viewModel: viewModel
            )
        }

        .sheet(isPresented: $viewModel.showSheetSettingTeam) {
            SettingsTeamDetailSheet(
                viewModel: viewModel,
                isAdmin: $viewModel.isUserAdmin
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
                
        }
    }
}

private struct SettingsTeamDetailSheet: View {
    @StateObject var viewModel: TeamFormViewModel
    @Binding var isAdmin: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 30) {
                if isAdmin {
                    HStack {
                        Image(.iconAdduser)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Button(
                            action: {
                                Logger.log("Ajouter des membres", level: .action)
                                viewModel.showSheetSettingTeam = false
                                viewModel.showFriendsList = true
                            },
                            label: {
                                Text("Ajouter des membres")
                                    .tokenFont(.Body_Inter_Medium_16)
                            })
                        Spacer()
                    }
                    
                    HStack {
                        Image(.iconCrown)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Button(
                            action: {
                                Logger.log("Edit Admin", level: .action)
                                viewModel.showSheetSettingTeam = false
                                viewModel.isAdminEditing = true
                            },
                            label: {
                                Text("Modifier les admins")
                                    .tokenFont(.Body_Inter_Medium_16)
                            })
                        Spacer()
                    }
                    
                    HStack {
                        Image(.iconEdit)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 20)
                        Button(
                            action: {
                                Logger.log("Modifier la team", level: .action)
                                viewModel.showSheetSettingTeam = false
                                viewModel.showEditTeam = true
                            },
                            label: {
                                Text("Modifier la team")
                                    .tokenFont(.Body_Inter_Medium_16)
                            })
                        Spacer()
                    }
                }
                HStack {
                    Image(.iconTrash)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Quitter la team", level: .action)
                            viewModel.showSheetSettingTeam = false
                        },
                        label: {
                            Text("Quitter la team")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
                }
            }
            .padding(.leading, 12)
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        TeamDetailView(show: .constant(true), coordinator: Coordinator())
    }.ignoresSafeArea()
}
