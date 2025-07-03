import SwiftUI

struct NotificationScreenView: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: NotificationViewModel
    @ObservedObject var user: User

    init(coordinator: Coordinator, user: User) {
        self.coordinator = coordinator
        self.user = user
        self._viewModel = StateObject(
            wrappedValue: NotificationViewModel(user: user))
    }

    @ViewBuilder
    func cellConstruction(notification: Notification) -> some View {
        switch notification.typeNotif {
            case "teamCreated":
            Text(notification.typeNotif).foregroundColor(.white)
            case "friendRequest":
                EmptyView()
            case "acceptedFriendRequest":
            NavigationLink(destination: {
                FriendProfileView(
                    coordinator: coordinator,
                    user: user,
                    friend: notification.userContact ?? UserContact()
                )
            }) {
                VStack {
                    CellResponseFriend(
                        userContact: notification.userContact ?? UserContact(),
                        timeStamp: notification.timestamp,
                        isAcceptedFriend: true
                    )
                }
            }

            // Text(notification.typeNotif).foregroundColor(.white)
            case "cfqCreated":
                CellInformationEvent(
                    userContact: notification.userContact ?? UserContact(),
                    bodyNotif: .cfqCreated,
                    notification: notification
                )
            case "turnCreated":
                CellInformationEvent(
                    userContact: notification.userContact ?? UserContact(),
                    bodyNotif: .turnCreated,
                    notification: notification
                )
            
            case "attending":
            Text(notification.typeNotif)
                .foregroundColor(.white)
        default:
            Text(notification.typeNotif)
                .foregroundColor(.white)
        }
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                    
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.notifications.sorted(by: { $0.timestamp > $1.timestamp}), id: \.uid) { notification in
                        cellConstruction(notification: notification)
                    }
                }
            }
        }
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: "Notifications")
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: true
        )
    }
}
