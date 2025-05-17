
import SwiftUI

struct TitleTurnCardFeedView: View {

    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    @State var status: TypeParticipateButton = .none

    init(turn: Turn, coordinator: Coordinator) {
        self.turn = turn
        self.coordinator = coordinator
    }

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

                Button(action: {

                }) {
                    Image(systemName: "message")
                        .foregroundColor(.white)
                }

                ButtonParticipate(
                    action: {
                        coordinator.turnSelected = turn
                        withAnimation {
                            coordinator.showTurnFeedDetail = true
                        }
                    },
                    selectedOption: (turn.adminContact?.uid == coordinator.user?.uid) ? .constant(.yes) : $status
                )
            }

            PreviewProfile(pictures: [], previewProfileType: .userComming)
                .padding(.vertical, 8)
        }
        /*
        .sheet(isPresented: $coordinator.showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $status)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(350)])
        }
         */
    }
}
