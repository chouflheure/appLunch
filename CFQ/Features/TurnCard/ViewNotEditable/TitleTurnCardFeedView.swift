
import SwiftUI

struct TitleTurnCardFeedView: View {

    var turn: Turn

    init(turn: Turn) {
        self.turn = turn
        
    }
    
    // TODO: Change with user
    var userProfileImage: UIImage = .profile


    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                CachedAsyncImageView(urlString: turn.adminContact?.profilePictureUrl ?? "", designType: .scaledToFill_Circle)
                    .frame(width: 40, height: 40)

                Text(turn.adminContact?.pseudo ?? "")
                    .tokenFont(.Body_Inter_Medium_16)
                    .lineLimit(1)

                Spacer()

                Button(action: {}) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(action: {
                    
                })
            }

            PreviewProfile(pictures: [], previewProfileType: .userComming)
                .padding(.vertical, 8)
        }
    }
}
