
import SwiftUI

struct FeedView: View {
    @ObservedObject var coordinator: Coordinator
    @EnvironmentObject var user: User
    var viewModel = FeedViewModel()

    var body: some View {
        VStack {
            HStack {
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
                
            }.padding(.horizontal, 12)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            SwitchStatusUserProfile(
                                viewModel: SwitchStatusUserProfileViewModel(user: user)
                            )
                            ForEach(coordinator.userFriends, id: \.self) { friend in
                                CirclePictureStatusAndPseudo(
                                    userPreview: friend,
                                    onClick: {
                                        withAnimation {
                                            coordinator.showProfileFriend = true
                                        }
                                    }
                                )
                                .frame(width: 60, height: 60)
                                .padding(.leading, 17)
                            }
                            .frame(height: 100)
                        }
                    }
                }
                
                Divider()
                    .background(.white)
                
                CFQCollectionView(coordinator: coordinator)
                
                Divider()
                    .background(.white)

                LazyVStack(spacing: 20) {
                    ForEach(viewModel.turns, id: \.self) { turn in
                        TurnCardFeedView(turn: turn)
                    }
                }
            }
        }.onAppear() {
            // viewModel.catchTurns()
        }
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
                    .padding(.horizontal, 16)
                
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
