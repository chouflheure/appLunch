
import SwiftUI

struct TitleTurnCardFeedView: View {

    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    @State var status: TypeParticipateButton = .none
    private var viewModel = TurnCardFeedViewModel()

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
                    .textCase(.lowercase)
                    .lineLimit(1)

                Spacer()

                Button(action: {
                    coordinator.turnSelected = turn
                    
                    coordinator.selectedConversation = Conversation(
                        uid: turn.messagerieUUID,
                        titleConv: turn.titleEvent,
                        pictureEventURL: "",
                        typeEvent: "",
                        eventUID: "",
                        lastMessageSender: "",
                        lastMessageDate: Date(),
                        lastMessage: "",
                        messageReader: [""]
                    )
                    withAnimation {
                        coordinator.showMessagerieScreen = true
                    }
                }) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(
                    action: {
                        coordinator.turnSelected = turn

                        withAnimation {
                            // coordinator.showTurnFeedDetail = true
                            // showTurnDetailFeed = true
                        }
                        
                        withAnimation {
                            coordinator.showSheetParticipateAnswers = coordinator.turnSelected?.adminContact?.uid != coordinator.user?.uid
                        }
                        
                    },
                    selectedOption: (turn.adminContact?.uid == coordinator.user?.uid) ? .constant(.yes) : $status
                )
            }

            PreviewProfile(pictures: [], previewProfileType: .userComming, numberUsers: 10)
                .padding(.vertical, 8)
        }
        .onAppear {
            if turn.participants.contains(where: { $0.contains(coordinator.user?.uid ?? "") }) {
                $status.wrappedValue = .yes
            }
            if turn.mayBeParticipate.contains(where: { $0.contains(coordinator.user?.uid ?? "") }) {
                $status.wrappedValue = .maybe
            }
            if turn.denied.contains(where: { $0.contains(coordinator.user?.uid ?? "") }) {
                $status.wrappedValue = .no
            }
        }
        /*
        .sheet(isPresented: $coordinator.showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $status)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(250)])
        }
         */
    }
}
