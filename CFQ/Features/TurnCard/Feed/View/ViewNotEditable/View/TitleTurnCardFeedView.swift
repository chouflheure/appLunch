import SwiftUI

struct TitleTurnCardFeedView: View {

    @ObservedObject var turn: Turn
    @ObservedObject var coordinator: Coordinator
    var user: User
    @State var showSheetParticipateAnswers: Bool = false
    private var viewModel = TurnCardFeedViewModel()

    init(turn: Turn, coordinator: Coordinator, user: User) {
        self.turn = turn
        self.coordinator = coordinator
        self.user = user
        self.turn.userUID = user.uid
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(turn.titleEvent)
                .tokenFont(.Title_Gigalypse_24)
                .padding(.bottom, 16)
                .bold()
                .textCase(.uppercase)

            HStack {
                if turn.admin == user.uid {
                    CachedAsyncImageView(
                        urlString: turn.adminContact?.profilePictureUrl ?? "",
                        designType: .scaledToFill_Circle
                    )
                    .frame(width: 50, height: 50)

                    Text(turn.adminContact?.pseudo ?? "")
                        .tokenFont(.Body_Inter_Medium_16)
                        .textCase(.lowercase)
                        .lineLimit(1)
                } else {
                    NavigationLink(
                        destination: FriendProfileView(
                            coordinator: coordinator,
                            user: user,
                            friend: turn.adminContact ?? UserContact()
                        )
                    ) {
                        CachedAsyncImageView(
                            urlString: turn.adminContact?.profilePictureUrl
                                ?? "",
                            designType: .scaledToFill_Circle
                        )
                        .frame(width: 50, height: 50)

                        Text(turn.adminContact?.pseudo ?? "")
                            .tokenFont(.Body_Inter_Medium_16)
                            .textCase(.lowercase)
                            .lineLimit(1)
                    }
                }

                Spacer()

                NavigationLink(
                    destination: MessagerieView(
                        coordinator: coordinator,
                        conversation: Conversation(
                            uid: turn.messagerieUUID,
                            titleConv: turn.titleEvent,
                            pictureEventURL: turn.pictureURLString,
                            typeEvent: "turn",
                            eventUID: turn.uid,
                            lastMessageSender: "",
                            lastMessageDate: Date(),
                            lastMessage: "",
                            messageReader: []
                        ),
                        turn: turn
                    )
                ) {
                    Image(.iconMessage)
                        .foregroundColor(.white)
                }

                ButtonParticipate(
                    action: {
                        withAnimation {
                            showSheetParticipateAnswers =
                                turn.adminContact?.uid != user.uid
                        }
                    },
                    selectedOption: (turn.adminContact?.uid == user.uid)
                    ? .constant(.yourEvent) : $turn.userStatusParticipate
                )
            }
        }
        .sheet(isPresented: $showSheetParticipateAnswers) {
            AllOptionsAnswerParticpateButton(
                participateButtonSelected: $turn.userStatusParticipate
            )
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(250)])
        }
        .onChange(of: turn.userStatusParticipate) { newValue in
            viewModel.addStatusUserOnTurn(
                userUID: user.uid, turn: turn, status: newValue)
        }
    }
}
