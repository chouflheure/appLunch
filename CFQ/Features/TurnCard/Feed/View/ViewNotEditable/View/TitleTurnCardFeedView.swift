
import SwiftUI

struct TitleTurnCardFeedView: View {

    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    @State var showSheetParticipateAnswers: Bool = false

    var userUID: String
    private var viewModel = TurnCardFeedViewModel()

    init(turn: Turn, coordinator: Coordinator, userUID: String) {
        self.turn = turn
        self.coordinator = coordinator
        self.userUID = userUID
        self.turn.userUID = userUID
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
                        withAnimation {
                            showSheetParticipateAnswers = turn.adminContact?.uid != userUID
                        }
                    },
                    selectedOption: (turn.adminContact?.uid == userUID) ? .constant(.yes) : $turn.userStatusParticipate
                )
            }
        
            /*
            PreviewProfile(
                friends: $team.friendsContact,
                showImages: $showImages,
                previewProfileType: .userMemberTeam
            )
            
            PreviewProfile(
                pictures: [],
                previewProfileType: .userComming,
                numberUsers: 10
            )
            .padding(.vertical, 8)
             */
        }
        .sheet(isPresented: $showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $turn.userStatusParticipate)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(250)])
        }
        .onChange(of: turn.userStatusParticipate) { newValue in
            viewModel.addStatusUserOnTurn(userUID: userUID, turn: turn, status: newValue)
        }
        /*
        .onAppear {
            if turn.participants.contains(where: { $0.contains(userUID) }) {
                userStatusParticipate = .yes
            }
            if turn.mayBeParticipate.contains(where: { $0.contains(userUID) }) {
                userStatusParticipate = .maybe
            }
            if turn.denied.contains(where: { $0.contains(userUID) }) {
                userStatusParticipate = .no
            }
        }
         */
        /*
        .sheet(isPresented: $coordinator.showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(participateButtonSelected: $status)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(250)])
        }
         */
    }
}
