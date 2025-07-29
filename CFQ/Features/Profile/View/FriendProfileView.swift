import SwiftUI

struct FriendProfileView: View {

    @StateObject var viewModel: FriendProfileViewModel
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var user: User
    @ObservedObject var friend: UserContact
    @Environment(\.dismiss) var dismiss
    @State private var showDetail = false
    @State private var showImages: Bool = false

    init(coordinator: Coordinator, user: User, friend: UserContact) {
        self.coordinator = coordinator
        self.user = user
        self.friend = friend

        self._viewModel = StateObject(
            wrappedValue: FriendProfileViewModel(
                coordinator: coordinator,
                user: user,
                friend: User(
                    uid: friend.uid,
                    name: friend.name,
                    firstName: friend.name,
                    pseudo: friend.pseudo,
                    profilePictureUrl: friend.profilePictureUrl,
                    isActive: friend.isActive
                )
            )
        )
    }

    var body: some View {

        VStack {
            HStack {
                CirclePictureStatus(
                    userPreview: UserContact(
                        uid: viewModel.userFriend.uid,
                        name: viewModel.userFriend.name,
                        pseudo: viewModel.userFriend.pseudo,
                        profilePictureUrl: viewModel.userFriend
                            .profilePictureUrl,
                        isActive: viewModel.userFriend.isActive
                    )
                )
                .frame(width: 70, height: 70)
                .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 12) {
                    PreviewPseudoName(
                        name: viewModel.userFriend.name,
                        pseudo: viewModel.userFriend.pseudo
                    )

                    HStack(alignment: .center) {
                        Image(.iconLocation)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        Text(viewModel.userFriend.location)
                            .tokenFont(.Body_Inter_Medium_16)
                    }
                }
                Spacer()

                Button(
                    action: {
                        viewModel.onclickAddFriend()
                    },
                    label: {
                        ZStack {
                            if viewModel.statusFriend != .requested {
                                Rectangle()
                                    .frame(width: 44, height: 44)
                                    .cornerRadius(10)
                                    .foregroundColor(
                                        viewModel.statusFriend
                                            .backgroungColorIcon)

                                Image(viewModel.statusFriend.icon)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)
                                    .overlay {
                                        RoundedRectangle(
                                            cornerRadius: 10
                                        )
                                        .stroke(
                                            viewModel.statusFriend
                                                .strokeColor,
                                            lineWidth: 0.5
                                        )
                                        .frame(width: 44, height: 44)
                                    }
                            } else {
                                Text("Accepter")
                                    .tokenFont(.Body_Inter_Medium_14)
                                    .padding(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                            }
                        }
                    })
            }
            .padding(.bottom, 16)

            VStack(alignment: .leading) {
                HStack {
                    Group {
                        if !showImages {
                            // Placeholder
                            HStack(spacing: -15) {
                                ForEach(0..<min(4,viewModel.userFriend.userFriendsContact?.count ?? 0),id: \.self) { index in
                                    Circle()
                                        .fill(.gray)
                                        .frame(width: 24, height: 24)
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    Color.white, lineWidth: 1)
                                        )
                                }
                            }
                        } else {
                            // Images réelles
                            HStack(spacing: -15) {
                                ForEach(
                                    Array((viewModel.friendsInCommun.compactMap({$0.profilePictureUrl})).prefix(4).enumerated()), id: \.offset) { index, imageUrl in
                                        CachedAsyncImageView(
                                            urlString: imageUrl,
                                            designType: .scaleImageMessageProfile
                                        )
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showImages)

                    NavigationLink(destination: {
                        FriendCommumScreen(
                            coordinator: coordinator,
                            friendInCommun: Set(viewModel.friendsInCommun),
                            userFriend: Set(viewModel.userFriend.userFriendsContact?.filter({$0.uid != user.uid}) ?? [])
                        )
                    }) {
                        if viewModel.friendsInCommun.count > 0 {
                            Text("\(viewModel.friendsInCommun.count)")
                                .foregroundStyle(.white)
                                .bold()

                            Text("Ami\(viewModel.friendsInCommun.count > 1 ? "s" : "") en commun")
                                .tokenFont(.Body_Inter_Medium_16)
                        } else {
                            Text("Pas d'ami en commun")
                                .tokenFont(.Body_Inter_Medium_16)
                        }
                    }

                    Spacer()
                }
                .frame(height: 24)
            }

            if viewModel.isPrivateAccount {
                PrivateEventShow()
            } else {
                CustomTabViewDoubleProfile(
                    coordinator: coordinator,
                    titles:  ["TURNs", "CALENDRIER"],
                    turnsPosted: viewModel.turnsInCommun(coordinator: coordinator),
                    turnsParticipate: viewModel.turnsInCommun(coordinator: coordinator),
                    user: user
                )
            }
        }
        .padding(.horizontal, 16)

        .sheet(isPresented: $viewModel.isShowingSettingsView) {
            SignalAndBlockUserSheet(viewModel: viewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(150)])
        }

        .blur(radius: viewModel.isShowRemoveFriends ? 10 : 0)
        .allowsHitTesting(!viewModel.isShowRemoveFriends)
        .onAppear {
            viewModel.statusFriendButton()
            viewModel.catchAllDataProfileUser(uid: friend.uid)
            showImages =
                viewModel.userFriend.userFriendsContact != nil
                && !(viewModel.userFriend.userFriendsContact?.isEmpty ?? true)
        }
        .onReceive(viewModel.userFriend.$userFriendsContact) { friendsContact in
            DispatchQueue.main.async {
                showImages =
                    friendsContact != nil && !(friendsContact?.isEmpty ?? true)
            }
        }
        .fullBackground(imageName: StringsToken.Image.fullBackground)
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                EmptyView()
            },
            rightElement: {
                Button(
                    action: {
                        viewModel.isShowingSettingsView = true
                    },
                    label: {
                        Image(.iconDots)
                            .foregroundColor(.white)
                            .frame(width: 24, height: 24)
                    })
            },
            hasADivider: false
        )

        if viewModel.isShowRemoveFriends {
            PopUpRemoveFromFriends(
                showPopup: $viewModel.isShowRemoveFriends, viewModel: viewModel)
        }

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
        VStack {
            Image(.iconLock)
                .resizable()
                .frame(width: 44, height: 44)
                .padding(.bottom, 16)
                .foregroundColor(.white)

            Text("COMPTE PRIVÉ")
                .tokenFont(.Body_Inter_Medium_16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 40)  // Ajuster selon vos besoins pour le centrage vertical
    }
}

struct PopUpRemoveFromFriends: View {
    @Binding var showPopup: Bool
    @StateObject var viewModel: FriendProfileViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("On retire de tes amis ?")
                    .tokenFont(.Title_Gigalypse_20)
                    .padding(.top, 30)
                    .padding(.horizontal, 15)
                    .multilineTextAlignment(.center)

                HStack(alignment: .center) {
                    Button(
                        action: {
                            showPopup = false
                            viewModel.statusFriend = .friend
                        },
                        label: {
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

                    Button(
                        action: {
                            viewModel.statusFriend = .noFriend
                            viewModel.actionOnClickButtonAddFriend(
                                type: .remove)
                            showPopup = false
                        },
                        label: {
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
