
import SwiftUI

struct FeedView: View {
    @EnvironmentObject var user: User
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: FeedViewModel

    init(coordinator: Coordinator) {
        _viewModel = StateObject(wrappedValue:FeedViewModel(coordinator: coordinator))
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Button(action: {
                    withAnimation {
                        coordinator.showFriendListScreen = true
                    }
                }) {
                    Image(.iconAddfriend)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }

                Spacer()

                NotificationButtonIcon(
                    numberNotificationUnRead: 0,
                    icon: .iconNotifs,
                    onTap: {
                    withAnimation {
                        coordinator.showNotificationScreen = true
                    }
                })

                NotificationButtonIcon(
                    numberNotificationUnRead: 10,
                    icon: .iconMessagerie,
                    onTap: {
                    withAnimation {
                        coordinator.showMessageScreen = true
                    }
                })
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            SwitchStatusUserProfile(
                                viewModel: SwitchStatusUserProfileViewModel(user: user)
                            )
                            .padding(.bottom, 8)
                            .padding(.leading, 16)

                            ForEach(coordinator.user?.userFriendsContact?.sorted(by: { $0.isActive && !$1.isActive }) ?? [], id: \.self) { friend in
                                CirclePictureStatusAndPseudo(
                                    userPreview: friend,
                                    onClick: {
                                        coordinator.profileUserSelected = User(
                                            uid: friend.uid,
                                            name: friend.name,
                                            pseudo: friend.pseudo,
                                            profilePictureUrl: friend.profilePictureUrl,
                                            isActive: friend.isActive
                                        )
                                        withAnimation {
                                            coordinator.showProfileFriend = true
                                        }
                                    }
                                )
                                .padding(.leading, 17)
                            }
                            .padding(.top, 15)
                            .frame(height: 120)
                        }
                    }
                }

                Divider()
                    .background(.white)
                
                CFQCollectionView(coordinator: coordinator)
                    .padding(.vertical, 5)
                
                Divider()
                    .background(.white)

                LazyVStack(spacing: 20) {
                    ForEach(viewModel.turns.sorted(by: { $0.timestamp > $1.timestamp }), id: \.uid) { turn in
                        TurnCardFeedView(turn: turn, coordinator: coordinator)
                            .padding(.horizontal, 12)
                    }
                }.padding(.top, 24)
            }
        }
        .padding(.top, 15)
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        FeedView(coordinator: .init())
    }.ignoresSafeArea()
}


struct NotificationButtonIcon: View {
    var numberNotificationUnRead: Int
    var icon: ImageResource
    var onTap: ( () -> Void )
    
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
