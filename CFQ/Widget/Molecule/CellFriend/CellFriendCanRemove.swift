
import SwiftUI

struct CellFriendCanRemove: View {
    var userPreview: UserContact
    var onRemove: (() -> Void)

    var body: some View {
        ZStack {
            CellRoundedImageAndName(userPreview: userPreview)

            Button(action: {
                onRemove()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 35, y: -30)
        }.background(.clear)
    }
}

struct CellTeamCanRemove: View {
    var team: Team
    var onRemove: (() -> Void)
    
    var body: some View {
        ZStack {
            CellRoundedImageAndName(
                userPreview: UserContact(
                    uid: team.uid,
                    pseudo: team.title,
                    profilePictureUrl: team.pictureUrlString
                )
            )
            
            Button(action: {
                onRemove()
            }) {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 8, height: 8)
                    .foregroundColor(.black)
                    .padding(6)
                    .background(Color.white)
                    .clipShape(Circle())
            }
            .offset(x: 35, y: -30)
        }.background(.clear)
    }
}

