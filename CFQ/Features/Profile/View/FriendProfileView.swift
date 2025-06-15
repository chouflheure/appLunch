import SwiftUI

struct FriendProfileView: View {

    @StateObject var viewModel: FriendProfileViewModel
    @ObservedObject var coordinator: Coordinator
    @State private var showDetail = false
    @State private var showImages: Bool = false
    @ObservedObject var user: User
    @ObservedObject var friend: UserContact
    @Environment(\.dismiss) var dismiss

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
                                    .padding(.all, 3)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(
                                                .white,
                                                lineWidth: 0.5)
                                    }
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
                                ForEach(
                                    0..<min(
                                        4,
                                        viewModel.userFriend.userFriendsContact?
                                            .count ?? 4),
                                    id: \.self
                                ) { index in
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
                                    Array(
                                        (viewModel.friendsInCommun.compactMap({
                                            $0.profilePictureUrl
                                        })).prefix(4).enumerated()),
                                    id: \.offset
                                ) { index, imageUrl in
                                    CachedAsyncImageView(
                                        urlString: imageUrl,
                                        designType: .scaleImageMessageProfile
                                    )
                                }
                            }
                        }
                    }
                    .animation(.easeInOut(duration: 0.3), value: showImages)

                    if viewModel.friendsInCommun.count > 0 {
                        Text("\(viewModel.friendsInCommun.count)")
                            .foregroundStyle(.white)
                            .bold()

                        Text(
                            "Ami\(viewModel.friendsInCommun.count > 1 ? "s" : "") en commun"
                        )
                        .foregroundStyle(.white)
                    } else {
                        Text("Pas d'ami en commun")
                    }
                    Spacer()
                }
                .frame(height: 24)
            }
            .onTapGesture {
                withAnimation {
                    coordinator.showFriendInCommum = true
                }
            }
            /*
                    HStack {
                        PreviewProfile(
                            pictures: [],
                            previewProfileType: .userFriendInCommun,
                            numberUsers: 12)
                        Spacer()
                    }
                     */

            if viewModel.isPrivateAccount {
                PrivateEventShow()
            } else {
                CustomTabViewDoubleProfile(
                    coordinator: coordinator, titles: ["TURNs", "CALENDRIER"],
                    turns: viewModel.turnsInCommun(coordinator: coordinator))
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
            // TODO: - call to have full user
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
        .customNavigationBackButton{
            HStack(alignment: .center) {
                Button(
                    action: {
                        dismiss()
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
        }
        
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
                            .foregroundColor(
                                selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 3)
                            .foregroundColor(
                                selectedIndex == index ? .white : .clear
                            )
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
