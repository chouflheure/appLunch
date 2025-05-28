import SwiftUI

struct FriendProfileView: View {

    @EnvironmentObject var user: User

    var profileFriend = User(
        uid: "77MKZdb3FJX8EFvlRGotntxk6oi1",
        name: "Profile",
        firstName: "Friend",
        pseudo: "Charles",
        location: "Ici",
        isPrivateAccount: true,
        requestsFriends: ["1234567890"]
    )

    @StateObject var viewModel = FriendProfileViewModel()
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showProfileFriend ) {
            SafeAreaContainer {
                VStack {
                    HStack(alignment: .center) {
                        Button(
                            action: {
                                withAnimation {
                                    coordinator.showProfileFriend  = false
                                }
                            },
                            label: {
                                Image(.iconArrow)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            })
                        Spacer()
                        Button(
                            action: {
                                viewModel.isShowingSettingsView = true
                            },
                            label: {
                                Image(.iconDots)
                                    .foregroundColor(.white)
                                    .frame(width: 24, height: 24)
                            })
                    }
                    .padding(.trailing, 12)
                    .padding(.bottom, 32)

                    HStack {
                        CirclePictureStatus(
                            userPreview: UserContact(
                                uid: coordinator.profileUserSelected.uid,
                                name: coordinator.profileUserSelected.name,
                                firstName: coordinator.profileUserSelected.firstName,
                                pseudo: coordinator.profileUserSelected.pseudo,
                                profilePictureUrl: coordinator.profileUserSelected.profilePictureUrl,
                                isActive: coordinator.profileUserSelected.isActive
                            ),
                            onClick: {}
                        )
                        .frame(width: 70, height: 70)
                        .padding(.trailing, 12)

                        
                        VStack(alignment: .leading, spacing: 12) {
                            PreviewPseudoName(
                                name: coordinator.profileUserSelected.name,
                                firstName: coordinator.profileUserSelected.firstName,
                                pseudo: coordinator.profileUserSelected.pseudo
                            )
                            
                            HStack(alignment: .center) {
                                Image(.iconLocation)
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(.white)
                                Text(coordinator.profileUserSelected.location)
                                    .tokenFont(.Body_Inter_Medium_16)
                            }
                        }
                        Spacer()
                        
                        if !viewModel.isRequestedToBeFriendByTheUser {
                            Button(
                                action: {
                                    viewModel.onclickAddFriend()
                                },
                                label: {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 44, height: 44)
                                            .cornerRadius(10)
                                            .foregroundColor(viewModel.statusFriend.backgroungColorIcon)
                                        
                                        Image(viewModel.statusFriend.icon)
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.white)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(viewModel.statusFriend.strokeColor, lineWidth: 0.5)
                                                    .frame(width: 44, height: 44)
                                            }
                                    }
                                })
                            .onAppear() {
                                // viewModel.statusFriendButton(user: user, friend: profileFriend)

                                // TODO: - call to have full user
                                viewModel.statusFriendButton(user: user, friend: coordinator.profileUserSelected)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                    
                    if viewModel.isRequestedToBeFriendByTheUser {
                        AnswerFriendToTheProfile(viewModel: viewModel, profileFriend: coordinator.profileUserSelected)
                    }

                    HStack {
                        PreviewProfile(pictures: [], previewProfileType: .userFriendInCommun, numberUsers: 12)
                        Spacer()
                    }
                    
                    if viewModel.isPrivateAccount && profileFriend.isPrivateAccount {
                        PrivateEventShow()
                    } else {
                        PageViewEventFriends()
                    }
                }
                .padding(.horizontal, 16)
                
                .sheet(isPresented: $viewModel.isShowingSettingsView) {
                    SignalAndBlockUserSheet(viewModel: viewModel)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(150)])
                }
            }
            .blur(radius: viewModel.isShowRemoveFriends ? 10 : 0)
            .allowsHitTesting(!viewModel.isShowRemoveFriends)
        }

        /*
        .onAppear() {
            viewModel.statusFriendButton(user: user, friend: coordinator.profileUserSelected)
        }
         */
        if viewModel.isShowRemoveFriends {
            PopUpRemoveFriendAlert(viewModel: viewModel)
        }
    }
}

struct PopUpRemoveFriendAlert: View {
    @StateObject var viewModel: FriendProfileViewModel

    var body: some View {
        Color.black.opacity(0.4)
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.isShowRemoveFriends = false
                viewModel.statusFriend = .friend
            }
            .zIndex(1)
        
        PopUpRemoveFromFriends(
            showPopup: $viewModel.isShowRemoveFriends,
            viewModel: viewModel
        )
        .zIndex(2)
    }
}

private struct SignalAndBlockUserSheet: View {
    @StateObject var viewModel: FriendProfileViewModel

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .trailing, spacing: 30) {
                HStack(spacing: 15) {
                    Image(.iconSignal)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Profile signalé", level: .action)
                            viewModel.isShowingSettingsView = false
                        },
                        label: {
                            Text("Signaler le profile")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
                }
                .padding(.leading, 12)

                HStack {
                    Image(.iconBlock)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    Button(
                        action: {
                            Logger.log("Profile bloqué", level: .action)
                            viewModel.isShowingSettingsView = false
                        },
                        label: {
                            Text("Bloquer le profile")
                                .tokenFont(.Body_Inter_Medium_16)
                        })
                    Spacer()
                }
                .padding(.leading, 12)
            }
        }
    }
}

private struct PrivateEventShow: View {
    var body: some View {
        VStack() {
            Image(.iconLock)
                .resizable()
                .frame(width: 44, height: 44)
                .padding(.bottom, 16)
                .foregroundColor(.white)
            
            Text("COMPTE PRIVÉ")
                .tokenFont(.Body_Inter_Medium_16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 40) // Ajuster selon vos besoins pour le centrage vertical
    }
}

private struct AnswerFriendToTheProfile: View {
    var viewModel: FriendProfileViewModel
    var profileFriend: User

    var body: some View {
        HStack {
            Text(profileFriend.pseudo + " " + StringsToken.Profile.AskAsFriend)
                .tokenFont(.Title_Gigalypse_20)
            Spacer()
            Button(
                action: {
                    viewModel.becomeFriend(answer: true)
                },
                label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .foregroundColor(viewModel.statusFriend.backgroungColorIcon)

                        Image(.iconAccept)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(viewModel.statusFriend.strokeColor, lineWidth: 0.5)
                                    .frame(width: 44, height: 44)
                            }
                    }
                })
            Button(
                action: {
                    viewModel.becomeFriend(answer: false)
                },
                label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 44, height: 44)
                            .cornerRadius(10)
                            .foregroundColor(.clear)
                        Image(.iconCross)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white, lineWidth: 0.5)
                                    .frame(width: 44, height: 44)
                            }
                    }
                })
        }
    }
}

struct PopUpRemoveFromFriends: View {
    @Binding var showPopup: Bool
    @StateObject var viewModel: FriendProfileViewModel

    var body: some View {
        ZStack() {
            VStack(spacing: 20) {
                Text("On retire de tes amis ?")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)
                
                HStack(alignment: .center) {
                    Button(action: {
                        showPopup = false
                        viewModel.statusFriend = .friend
                    }, label: {
                        Text("Non garder")
                            .tokenFont(.Label_Gigalypse_12)
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                            lineWidth: 5
                                    )
                                    .frame(width: 130, height: 40)
                            }
                    })

                    Spacer()

                    Button(action: {
                        viewModel.statusFriend = .noFriend
                        showPopup = false
                    }, label: {
                        Text("Yes, retirer")
                            .tokenFont(.Label_Gigalypse_12)
                    })
                }
                .padding(.horizontal, 35)
                .padding(.top, 20)
            }
            .frame(width: 300, height: 200)
            .background(.blackCard)
            .cornerRadius(12)
            .zIndex(2)

            ZStack {
                Circle()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.purpleText)
                    .shadow(radius: 10)

                Image(.iconBye)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .offset(x: 0, y: 15)
            }
            .offset(y: -110)
            .zIndex(3)
        }
    }
}


struct PageViewEventFriends: View {
    @State private var selectedIndex = 0
    let titles = ["TURNs", "CALENDRIER"]

    var body: some View {
        VStack {
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }
            .padding(.top, 20)

            TabView(selection: $selectedIndex) {
                Text(StringsToken.Profile.NoTurnAtThisMoment)
                    .foregroundColor(.white)
                    .tag(0)
                Text(StringsToken.Profile.NoTurnAtThisMoment)
                    .foregroundColor(.white)
                    .tag(1)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        }
    }
}

struct FriendProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileView(coordinator: Coordinator())
    }
}
