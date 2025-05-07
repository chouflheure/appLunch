
import SwiftUI

struct TitleTurnCardFeedView: View {

    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
    }
    
    // TODO: Change with user
    var userProfileImage: UIImage = .profile

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: "Ici"
    )

    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Inter_semibold_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                Image(uiImage: userProfileImage)

                Text(turn.admin)
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {})
            }

            PreviewProfile(pictures: [], previewProfileType: .userComming)
                .padding(.vertical, 8)
        }
    }
}
