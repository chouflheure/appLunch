
import SwiftUI

struct CellFriendPseudoNameAction: View {
    enum CellFriendPseudoNameActionType {
        case remove
        case add
    }
    
    var user: UserContact
    var coordinator: Coordinator
    var type: CellFriendPseudoNameActionType
    var isActionabled: (() -> Void)
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                CirclePicture(urlStringImage: user.profilePictureUrl)
                    .frame(width: 48, height: 48)
                VStack(alignment: .leading) {
                    Text(user.pseudo)
                        .foregroundColor(.white)
                        .lineLimit(1)
                    HStack {
                        Text(user.name)
                            .tokenFont(.Body_Inter_Regular_12)
                        Text((user.firstName.first?.uppercased() ?? "") + ".")
                            .tokenFont(.Body_Inter_Regular_12)
                    }
                }.padding(.leading, 8)
                
                Spacer()
            }
            .onTapGesture {
                withAnimation {
                    coordinator.profileUserSelected = User(
                        uid: user.uid,
                        name: user.name,
                        firstName: user.firstName,
                        pseudo: user.pseudo,
                        profilePictureUrl: user.profilePictureUrl
                    )
                    coordinator.showProfileFriend = true
                }
            }
            
            Button(action: {
                isActionabled()
            }) {
                if type == .remove {
                    Text("Supprimer")
                        .tokenFont(.Body_Inter_Medium_14)
                } else {
                    Image(.iconCross)
                        .resizable()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: 45))
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
