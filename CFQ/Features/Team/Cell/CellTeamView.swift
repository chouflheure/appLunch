
import SwiftUI

struct CellTeamView: View {
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var team: Team
    @State private var showImages = false

    var body: some View {
        HStack(alignment: .center) {
            CirclePicture(urlStringImage: team.pictureUrlString)
                .frame(width: 50, height: 50)
            VStack(alignment: .leading, spacing: 10) {
                Text(team.title)
                    .foregroundColor(.white)
                    .bold()

                PreviewProfile(
                    friends: $team.friendsContact,
                    showImages: $showImages,
                    previewProfileType: .userMemberTeam
                )
                .frame(height: 24)
            }.padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white, lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onReceive(team.$friendsContact) { friendsContact in
            DispatchQueue.main.async {
                showImages = friendsContact != nil && !(friendsContact?.isEmpty ?? true)
            }
        }
        .onAppear {
            showImages = team.friendsContact != nil && !(team.friendsContact?.isEmpty ?? true)
        }
    }
}
