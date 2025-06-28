import Combine
import SwiftUI
import UIKit

struct MessagerieView: View {

    @StateObject var viewModel: MessagerieViewModel
    @ObservedObject var coordinator: Coordinator

    @State private var text: String = ""
    @State private var lastText: String = ""
    @State private var showReaction: Bool = false
    @State private var isKeyboardVisible = false
    @State private var textViewHeight: CGFloat = 20
    @State private var keyboardHeight: CGFloat = 0
    @EnvironmentObject var user: User

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
                            VStack {
                                ForEach((0..<viewModel.messages.count).reversed(), id: \.self) { index in
                                    LazyVStack(spacing: 4) {
                                        
                                        if viewModel.messages[index].senderUID == coordinator.user?.uid {
                                            CellMessageSendByTheUserView(data: viewModel.messages[index]) {}
                                            .padding(.horizontal, 12)
                                            .rotationEffect(.degrees(180))
                                        } else {
                                            CellMessageViewReceived(data: viewModel.messages[index])
                                            .padding(.horizontal, 12)
                                            .rotationEffect(.degrees(180))
                                        }
                                    }
                                }
                                .padding(.bottom, 15)
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
                        .frame(height: textViewHeight + 40)
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

        //if showReaction {
        //  destinationView()
        // .transition(.move(edge: .trailing))
        //    .zIndex(2)
        // ReactionPreviewView(showReaction: $showReaction)
        //}

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
                    NavigationCFQHeader(cfq: editHeader(cfq: cfqFromCache))        
                }
                
                if let cfqFromCache = user.postedCfqs?.first(where: { $0 == conversation.eventUID }) {
                    NavigationCFQHeader(cfq: CFQ(uid: cfqFromCache, title: conversation.titleConv, admin: user.uid, messagerieUUID: conversation.uid, users: [], timestamp: Date(), userContact: UserContact(uid: user.uid, pseudo: user.pseudo, profilePictureUrl: user.profilePictureUrl)))
                }
                else {
                    NavigationCFQHeader(cfq: editHeader(cfq: cfq ?? CFQ(uid: conversation.eventUID, title: conversation.titleConv, admin: user.uid, messagerieUUID: conversation.uid, users: [], timestamp: Date(), userContact: UserContact(uid: user.uid, pseudo: user.pseudo, profilePictureUrl: user.profilePictureUrl))))
                }
            } else {
                NavigationCFQHeader(cfq: editHeader(cfq: cfq ?? CFQ(uid: "", title: "", admin: "", messagerieUUID: "", users: [], timestamp: Date(), participants: [], userContact: nil)))
            }
        }
    }
    
    private func editHeader(cfq: CFQ) -> CFQ {
        print("@@@ cfq.admin = \(cfq.admin)")
        if cfq.admin == user.uid {
            print("@@@ in 1er if")
            print("@@@ user.uid = \(user.uid)")
            print("@@@ user.pseudo = \(user.pseudo)")

            cfq.userContact = UserContact(
                uid: user.uid,
                pseudo: user.pseudo,
                profilePictureUrl: user.profilePictureUrl
            )
            return cfq
        } else if let userContact = user.userFriendsContact?.first(where: { $0.uid == cfq.admin }) {
            print("@@@ in 2eme if")
            cfq.userContact = userContact
            print("@@@ cfq = \(cfq.printObject)")
            print("\n @@@ userContact uid: \(userContact.uid)")
            print("\n @@@ userContact pseudo: \(userContact.pseudo)")
            print("\n @@@ userContact profilePictureUrl: \(userContact.profilePictureUrl)")
            return cfq
        }

        
        return cfq
    }
}

struct ConversationOptionView: View {
    @Binding var isPresented: Bool

    var body: some View {
        DraggableViewLeft(isPresented: $isPresented) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: { withAnimation { isPresented = false } },
                        titleScreen: "Infos"
                    )

                    /*
                    ScrollView {
                        VStack {
                            Image(.header)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            Text("Titre du groupe")
                                .tokenFont(.Title_Inter_semibold_24)

                            // MEDIA PART
                            ConversationOptionPart(
                                icon: .iconAdduser, title: "Ajouter quelqu'un",
                                onTap: {})
                            ConversationOptionPart(
                                icon: .iconSearch,
                                title: "Rechercher dans la conv", onTap: {})
                            ConversationOptionPart(
                                icon: .icon, title: "Medias", nbElement: 8,
                                onTap: {})

                            PageView(pageViewType: .invited)
                                .frame(height: 300)

                            Spacer()

                            Button("coucou", action: {})
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 12)
                    */

                }
            }
            .ignoresSafeArea(.keyboard)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
        }
    }
}

private struct ConversationOptionPart: View {
    var icon: ImageResource
    var title: String
    var nbElement: Int?
    var onTap: () -> Void

    var body: some View {
        HStack {
            Image(icon)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            Text(title)
                .tokenFont(.Body_Inter_Medium_16)
            Spacer()
            Text(nbElement != nil ? "\(nbElement!)" : "")
                .tokenFont(.Placeholder_Inter_Regular_16)
            Image(.iconArrow)
                .resizable()
                .scaledToFill()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .rotationEffect(.init(degrees: 180))

        }
        .padding()
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.whiteTertiary, lineWidth: 1)
        }
        .onTapGesture {
            onTap()
        }
    }
}

#Preview {
    ZStack {
        NeonBackgroundImage()
        ConversationOptionView(isPresented: .constant(false))
    }
}
