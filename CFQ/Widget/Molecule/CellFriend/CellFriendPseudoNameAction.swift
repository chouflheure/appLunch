
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
            .onTapGesture {
                coordinator.profileUserSelected = User(
                    uid: userFriend.uid,
                    name: userFriend.name,
                    pseudo: userFriend.pseudo,
                    profilePictureUrl: userFriend.profilePictureUrl
                )
                withAnimation {
                    coordinator.showProfileFriend = true
                }
            }
            .simultaneousGesture(TapGesture())

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
