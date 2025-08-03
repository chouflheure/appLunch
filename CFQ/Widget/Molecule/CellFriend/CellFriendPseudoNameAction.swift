import SwiftUI

enum CellFriendPseudoNameActionType: String {
    case remove = "Supprimer"
    case add = ""
    case accept = "Accepter"
    case cancel = "Annuler"
}

struct CellFriendPseudoNameAction: View {

    @ObservedObject var user: User
    var userFriend: UserContact
    var coordinator: Coordinator
    var isActionabled: ((CellFriendPseudoNameActionType) -> Void)

    private var currentType: CellFriendPseudoNameActionType {
        if user.friends.contains(userFriend.uid) {
            return .remove
        }
        if user.sentFriendRequests.contains(userFriend.uid) {
            return .cancel
        }
        if user.requestsFriends.contains(userFriend.uid) {
            return .accept
        } else {
            return .add
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: {
                FriendProfileView(
                    coordinator: coordinator,
                    user: user,
                    friend: userFriend
                )
            }) {
                HStack {
                    CirclePicture(urlStringImage: userFriend.profilePictureUrl)
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading) {
                        Text(userFriend.pseudo)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        HStack {
                            Text(userFriend.name)
                                .tokenFont(.Body_Inter_Regular_12)
                        }
                    }.padding(.leading, 8)

                    Spacer()
                }
                .contentShape(Rectangle())
            }

            Button(action: {
                isActionabled(currentType)
            }) {
                if currentType == .add {
                    Image(.iconCross)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 45))
                } else {
                    Text(currentType.rawValue)
                        .tokenFont(.Body_Inter_Medium_14)
                }
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 1)
            )
        }
    }
}

struct CellFriendPseudoNameActionRequestFriendView: View {

    @ObservedObject var user: User
    var userFriend: UserContact
    var coordinator: Coordinator
    var isActionabled: ((CellFriendPseudoNameActionType) -> Void)
    var isRemoveFriendRequest: (() -> Void)

    private var currentType: CellFriendPseudoNameActionType {
        if user.friends.contains(userFriend.uid) {
            return .remove
        }
        if user.sentFriendRequests.contains(userFriend.uid) {
            return .cancel
        }
        if user.requestsFriends.contains(userFriend.uid) {
            return .accept
        } else {
            return .add
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            NavigationLink(destination: {
                FriendProfileView(
                    coordinator: coordinator,
                    user: user,
                    friend: userFriend
                )
            }) {
                HStack {
                    CirclePicture(urlStringImage: userFriend.profilePictureUrl)
                        .frame(width: 48, height: 48)
                    VStack(alignment: .leading) {
                        Text(userFriend.pseudo)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        HStack {
                            Text(userFriend.name)
                                .tokenFont(.Body_Inter_Regular_12)
                        }
                    }.padding(.leading, 8)

                    Spacer()
                }
                .contentShape(Rectangle())
            }

            HStack {
                Button(action: {
                    isActionabled(currentType)
                }) {
                    if currentType == .add {
                        Image(.iconCross)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                            .rotationEffect(Angle(degrees: 45))
                    } else {
                        Text(currentType.rawValue)
                            .tokenFont(.Body_Inter_Medium_14)
                    }
                }
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )

                if currentType != .add {
                    Button(action: {
                        isRemoveFriendRequest()
                    }) {
                        Image(.iconCross)
                            .resizable()
                            .frame(width: 14, height: 14)
                            .foregroundColor(.white)
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 1)
                    )
                }
            }
        }
    }
}
