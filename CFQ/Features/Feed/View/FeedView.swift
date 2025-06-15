import SwiftUI

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
                                viewModel: SwitchStatusUserProfileViewModel(
                                    user: user)
                            )
                            .padding(.bottom, 8)
                            .padding(.leading, 16)
/*
                            ForEach(
                                coordinator.user?.userFriendsContact?.sorted(
                                    by: { $0.isActive && !$1.isActive }) ?? [],
                                    id: \.self
                            ) { friend in
                                
                                CirclePictureStatusAndPseudo(
                                    userPreview: friend
                                    
                                        /*
                                        coordinator.profileUserSelected = User(
                                            uid: friend.uid,
                                            name: friend.name,
                                            pseudo: friend.pseudo,
                                            profilePictureUrl: friend
                                                .profilePictureUrl,
                                            isActive: friend.isActive
                                        )
                                         */
                                        // withAnimation {
                                            // coordinator.showProfileFriend = true
                                        // }
                                    
                                )
                                .padding(.leading, 17)
                            
                            }
                            .padding(.top, 15)
                            .frame(height: 120)
 */
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
                    ForEach(
                        viewModel.turns.sorted(by: {
                            $0.timestamp > $1.timestamp
                        }), id: \.uid
                    ) { turn in
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

// MARK: - FeedView Principal avec Navigation
struct FeedView_Nav: View {
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
            // Header avec boutons de navigation
            HStack(spacing: 14) {
                NavigationLink(
                    destination: AddFriendsScreen(coordinator: coordinator)
                ) {
                    Image(.iconAddfriend)
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                }

                Spacer()

                NavigationLink(
                    destination: NotificationScreenView(coordinator: coordinator)
                ) {
                    NotificationButtonIcon_Nav(
                        numberNotificationUnRead: 0,
                        icon: .iconNotifs
                    )
                }

                // TODO: - Edit
                NavigationLink(
                    destination: MessageView(coordinator: coordinator)
                ) {
                    NotificationButtonIcon_Nav(
                        numberNotificationUnRead: 10,
                        icon: .iconMessagerie
                    )
                }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 20)

            // Contenu principal du feed
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Status des amis (horizontal scroll)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            SwitchStatusUserProfile(
                                viewModel: SwitchStatusUserProfileViewModel(
                                    user: user)
                            )
                            .padding(.bottom, 8)
                            .padding(.leading, 16)

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
                            .frame(height: 120)
                        }
                    }
                }

                Divider()
                    .background(.white)

                // Navigation vers CFQ Collection
                NavigationLink(
                    destination: CFQCollectionDetailView(
                        coordinator: coordinator)
                ) {
                    CFQCollectionView(coordinator: coordinator)
                        .padding(.vertical, 5)
                }

                Divider()
                    .background(.white)

                // Liste des turns avec navigation
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.turns.sorted(by: { $0.timestamp > $1.timestamp}),
                            id: \.uid) { turn in
                        
                        NavigationLink(
                            destination: TurnCardDetailsFeedView(
                                coordinator: coordinator, turn: turn)
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

// MARK: - Views de destination
struct FriendListView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Liste des amis")
                .font(.title)

            // Contenu de la liste d'amis
            Text("Ici vous pouvez voir tous vos amis")
                .foregroundColor(.secondary)
                .padding()
        }
        .navigationTitle("Amis")
        .customNavigationBackButton {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Feed")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct NotificationView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Notifications")
                .font(.title)

            // Liste des notifications
            List {
                Text("Notification 1")
                Text("Notification 2")
                Text("Notification 3")
            }
        }
        .navigationTitle("Notifications")
        .customNavigationBackButton {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Retour")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct MessageView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Messages")
                .font(.title)

            // Liste des messages
            List {
                Text("Message 1")
                Text("Message 2")
                Text("Message 3")
            }
        }
        .navigationTitle("Messages")
        .customNavigationBackButton {
            Button(action: { dismiss() }) {
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 18))
                    Text("Feed")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ProfileFriendView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Profil de Test")
                .font(.title)
        }
        .navigationTitle("Profil")
        .customNavigationBackButton {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "person.circle")
                        .font(.system(size: 18))
                    Text("Feed")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct TurnDetailView: View {
    @Environment(\.dismiss) var dismiss
    let turn: Turn  // Remplacez par votre type Turn
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Détail du Turn")
                .font(.title)

            // Détails du turn
            Text("Turn ID: \(turn.uid)")
                .padding()
        }
        .navigationTitle("Turn")
        .customNavigationBackButton {
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .medium))
                    Text("Feed")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct CFQCollectionDetailView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Collection CFQ")
                .font(.title)

            // Contenu de la collection
            Text("Détails de la collection CFQ")
                .padding()
        }
        
        .customNavigationBackButton {
            
            Button(action: { dismiss() }) {
                HStack(spacing: 4) {
                    Image(systemName: "square.grid.3x3")
                        .font(.system(size: 16, weight: .medium))
                    Spacer()
                    Text("Feed Détails de la collection CFQ")
                        .font(.system(size: 17))
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct NotificationButtonIcon_Nav: View {
    var numberNotificationUnRead: Int
    var icon: ImageResource

    var body: some View {
        ZStack {
            Image(icon)
                .frame(width: 24, height: 24)
                .foregroundColor(.white)

            if numberNotificationUnRead > 0 {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .offset(x: 12, y: -12)
                    .overlay(
                        Text("\(numberNotificationUnRead)")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundColor(.white)
                            .offset(x: 12, y: -12)
                    )
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
