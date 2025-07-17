import Combine
import SwiftUI
import UIKit

struct MessagerieView: View {

    @StateObject var viewModel: MessagerieViewModel
    @ObservedObject var coordinator: Coordinator
    @EnvironmentObject var user: User

    @State private var text: String = ""
    @State private var lastText: String = ""
    @State private var showReaction: Bool = false
    @State private var isKeyboardVisible = false
    @State private var textViewHeight: CGFloat = 20
    @State private var keyboardHeight: CGFloat = 0

    @ObservedObject var conversation: Conversation
    var turn: Turn?
    var cfq: CFQ?

    init(coordinator: Coordinator, conversation: Conversation, turn: Turn? = nil, cfq: CFQ? = nil) {
        self.coordinator = coordinator
        self.conversation = conversation
        self.turn = turn
        self.cfq = cfq

        _viewModel = StateObject(
            wrappedValue: MessagerieViewModel(coordinator: coordinator, conversation: conversation)
        )
    }

    var body: some View {

        VStack {
            ZStack {
                /*
                Image(.background3)
                 .resizable()
                .opacity(0.8)
                .ignoresSafeArea()
            */

                VStack(spacing: 0) {
                    ScrollViewReader { proxy in
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 0) {
                                ForEach((0..<viewModel.messages.count).reversed(), id: \.self) { index in
                                    LazyVStack(spacing: 0) {
                                        if viewModel.messages[index].senderUID == coordinator.user?.uid {
                                            CellMessageSendByTheUserView(
                                                data: viewModel.messages[index],
                                                isSameLastSender: index > 0 && viewModel.messages[index].senderUID == viewModel.messages[index-1].senderUID
                                            ) {}
                                            .padding(.horizontal, 12)
                                            .rotationEffect(.degrees(180))

                                        } else {
                                            CellMessageViewReceived(
                                                data: viewModel.messages[index],
                                                isSameLastSender: index > 0 && viewModel.messages[index].senderUID == viewModel.messages[index-1].senderUID
                                            )
                                            .padding(.horizontal, 12)
                                            .rotationEffect(.degrees(180))
                                        }
                                    }
                                }
                                .padding(.bottom, 5)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .rotationEffect(.degrees(180))
                        .onChange(of: viewModel.messages.count) {_ in
                            withAnimation(.easeOut(duration: 0.3)) {
                                proxy.scrollTo(viewModel.messages.count - 1,anchor: .top)
                            }
                        }

                    }
                    Spacer()
                        .frame(height: textViewHeight + 50)
                }

                VStack {
                    Spacer()
                    GeometryReader { geometry in
                        HStack(alignment: .bottom) {
                            GrowingTextView(
                                text: $viewModel.textMessage,
                                dynamicHeight: $textViewHeight,
                                availableWidth: geometry.size.width - 80,
                                placeholder: "Ecris ici..."
                            )
                            .frame(height: textViewHeight)
                            .padding(8)
                            .background(.black)
                            .cornerRadius(24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8).stroke(
                                    Color.gray))

                            if !viewModel.textMessage.isEmpty {
                                Button(action: {
                                    viewModel.pushMessage()
                                }) {
                                    Image(.iconSend)
                                        .foregroundColor(.white)
                                        .padding(5)
                                        .background(.purpleDark)
                                        .clipShape(Circle())
                                }
                                .frame(width: 15, height: 15)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 10)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(
                            .bottom,
                            keyboardHeight == 0 ? 30 : keyboardHeight)
                    }
                    .frame(height: textViewHeight + 30)
                }
            }
            .blur(radius: showReaction ? 10 : 0)
            .allowsHitTesting(!showReaction)
            // .ignoresSafeArea()
        }
        .scrollDismissesKeyboard(.immediately)
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                centerNavigationElement
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: true
        )
    }

    @ViewBuilder
    private var centerNavigationElement: some View {
        if conversation.typeEvent == "turn" {
            if turn == nil {
               let turnFromCache = coordinator.userTurns.first(where: { $0.uid == conversation.eventUID })
                NavigationLink(destination: TurnCardDetailsFeedView(coordinator: coordinator, turn: turnFromCache ?? Turn(uid: conversation.eventUID, titleEvent: "", dateStartEvent: nil, pictureURLString: "", admin: "", description: "", invited: [], participants: [], denied: [], mayBeParticipate: [], mood: [], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0, timestamp: Date()), user: user))
                {
                    NavigationTitle(title: conversation.titleConv)
                }
            } else {
                NavigationLink(destination: TurnCardDetailsFeedView(coordinator: coordinator, turn: turn ?? Turn(uid: conversation.eventUID, titleEvent: "", dateStartEvent: nil, pictureURLString: "", admin: "", description: "", invited: [], participants: [], denied: [], mayBeParticipate: [], mood: [], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0, timestamp: Date()), user: user))
                {
                    NavigationTitle(title: conversation.titleConv)
                }
            }
        } else {
            if cfq == nil {
                if let cfqFromCache = coordinator.userCFQ.first(where: { $0.uid == conversation.eventUID }) {
                    NavigationLink(destination: ConversationOptionCFQView(cfq: cfqFromCache, coordinator: coordinator)) {
                        NavigationCFQHeader(cfq: editHeader(cfq: cfqFromCache))
                    }
                }
                
                if let cfqFromCache = user.postedCfqs?.first(where: { $0 == conversation.eventUID }) {
                    let cfq = CFQ(uid: cfqFromCache, title: conversation.titleConv, admin: user.uid, messagerieUUID: conversation.uid, users: [], timestamp: Date(), userContact: UserContact(uid: user.uid, pseudo: user.pseudo, profilePictureUrl: user.profilePictureUrl))
                    NavigationLink(destination: ConversationOptionCFQView(cfq: cfq, coordinator: coordinator)) {
                        NavigationCFQHeader(cfq: cfq)
                    }
                }
                else {
                    let cfq = editHeader(cfq: cfq ?? CFQ(uid: conversation.eventUID, title: conversation.titleConv, admin: user.uid, messagerieUUID: conversation.uid, users: [], timestamp: Date(), userContact: UserContact(uid: user.uid, pseudo: user.pseudo, profilePictureUrl: user.profilePictureUrl)))
                    NavigationLink(destination: ConversationOptionCFQView(cfq: cfq, coordinator: coordinator)) {
                        NavigationCFQHeader(cfq: cfq)
                    }
                }
            } else {
                let cfq = editHeader(cfq: cfq ?? CFQ(uid: "", title: "", admin: "", messagerieUUID: "", users: [], timestamp: Date(), participants: [], userContact: nil))
                NavigationLink(destination: ConversationOptionCFQView(cfq: cfq, coordinator: coordinator)) {
                    NavigationCFQHeader(cfq: cfq)
                }
            }
        }
    }
    
    private func editHeader(cfq: CFQ) -> CFQ {
        if cfq.admin == user.uid {
            cfq.userContact = UserContact(
                uid: user.uid,
                pseudo: user.pseudo,
                profilePictureUrl: user.profilePictureUrl
            )
            return cfq
        } else if let userContact = user.userFriendsContact?.first(where: { $0.uid == cfq.admin }) {
            cfq.userContact = userContact
            return cfq
        }

        
        return cfq
    }
}

