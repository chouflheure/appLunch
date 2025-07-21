import SwiftUI

struct NotificationButtonIcon: View {
    var numberNotificationUnRead: Int
    var icon: ImageResource
    var onTap: (() -> Void)

    var body: some View {
        Button(action: {
            withAnimation {
                onTap()
            }
        }) {
            ZStack {
                Image(icon)
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)

                if numberNotificationUnRead > 0 {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 12, height: 12)
                        .offset(x: 12, y: -12)
                }
            }
        }
    }
}

struct FeedView: View {
    @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: FeedViewModel

    init(coordinator: Coordinator) {
        _viewModel = StateObject(
            wrappedValue: FeedViewModel(coordinator: coordinator))
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                NavigationLink(
                    destination: AddFriendsScreen(coordinator: coordinator)
                ) {
                    NotificationButtonIcon_Nav(
                        hasNotificationUnRead: !user.requestsFriends.isEmpty,
                        icon: .iconAddfriend
                    )
                }

                Spacer()

                NavigationLink(
                    destination: NotificationScreenView(coordinator: coordinator, user: user)
                ) {
                    NotificationButtonIcon_Nav(
                        hasNotificationUnRead: user.someNotificationUnread ?? false,
                        icon: .iconNotifs
                    )
                }

                // TODO: - Edit
                NavigationLink(
                    destination: ConversationsView(coordinator: coordinator)
                ) {
                    NotificationButtonIcon_Nav(
                        hasNotificationUnRead: !(user.arrayConversationUnread?.isEmpty ?? true),
                        icon: .iconMessagerie
                    )
                }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    HStack(spacing: 0) {
                        Text("Qui sort ce soir ?")
                            .tokenFont(.Body_Inter_Regular_10)
                            .padding(.leading, 15)
                        Spacer()
                    }
                    .padding(.top, 15)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            SwitchStatusUserProfile(
                                viewModel: SwitchStatusUserProfileViewModel(
                                    user: user)
                            )
                            .padding(.bottom, 8)
                            .padding(.leading, 16)
                            .frame(height: 120)

                            ForEach(coordinator.user?.userFriendsContact?.sorted(by: { $0.isActive && !$1.isActive }) ?? [], id: \.uid) { friend in
                                NavigationLink(
                                    destination: FriendProfileView(
                                        coordinator: coordinator,
                                        user: user,
                                        friend: friend
                                    )
                                ) {
                                    CirclePictureStatusAndPseudo(
                                        userPreview: friend
                                    )
                                    .padding(.leading, 17)
                                }
                            }
                            .padding(.top, 15)
                        }
                    }
                }
                .frame(height: 150)

                ZStack {
                    Divider()
                        .background(.white)
                    
                    HStack {
                        Text("CFQ")
                            .tokenFont(.Body_Inter_Regular_10)
                            .background(.black)
                            .padding(.leading, 15)
                        Spacer()
                    }
                }
                

                CFQCollectionView(coordinator: coordinator)
                    .padding(.vertical, 5)
                

                ZStack {
                    Divider()
                        .background(.white)
                    
                    HStack {
                        Text("Turn - Event")
                            .tokenFont(.Body_Inter_Regular_10)
                            .background(.black)
                            .padding(.leading, 15)
                        Spacer()
                    }
                }

                // Liste des turns avec navigation
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.turns.sorted(by: { $0.timestamp > $1.timestamp}), id: \.uid) { turn in
                        NavigationLink(
                            destination: TurnCardDetailsFeedView(
                                coordinator: coordinator,
                                turn: turn,
                                user: user
                            )
                        ) {
                            TurnCardFeedView(
                                turn: turn, coordinator: coordinator
                            )
                            .padding(.horizontal, 12)
                        }
                    }
                }.padding(.top, 24)
            }
        }
        .padding(.top, 15)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationButtonIcon_Nav: View {
    // var numberNotificationUnRead: Int
    var hasNotificationUnRead: Bool
    var icon: ImageResource

    var body: some View {
        ZStack {
            Image(icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)

            //if numberNotificationUnRead > 0 {
            if hasNotificationUnRead {
                Circle()
                    .fill(.purpleText)
                    .frame(width: 12, height: 12)
                    .offset(x: 12, y: -12)
                /*
                    .overlay(
                        Text("\(numberNotificationUnRead)")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: 12, y: -12)
                    )
                 */
            }
        }
    }
}




#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView(coordinator: .init())
    }.ignoresSafeArea()
}
