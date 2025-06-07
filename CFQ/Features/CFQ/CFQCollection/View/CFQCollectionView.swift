
import SwiftUI
import FirebaseFirestore
import Lottie

struct CFQCollectionView: View {
    @ObservedObject var coordinator: Coordinator
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    Button(
                        action: {
                            withAnimation {
                                coordinator.showCFQForm = true
                            }
                            Logger.log("Click on Add CFQ", level: .action)
                        },
                        label: {
                            Image(.iconPlus)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                    ).padding(.leading, 20)
                    ForEach(coordinator.userCFQ.sorted(by: { $0.timestamp > $1.timestamp }), id: \.uid) { cfq in
                        // ??
                        if let userAdmin = coordinator.user?.userFriendsContact?.first(where: { $0.uid == cfq.admin }) {
                            CFQMolecule(
                                name: userAdmin.pseudo,
                                title: cfq.title,
                                image: userAdmin.profilePictureUrl
                            )
                            .onTapGesture {
                                coordinator.selectedCFQ = CFQ(
                                    uid: cfq.uid,
                                    title: cfq.title,
                                    admin: cfq.admin,
                                    messagerieUUID: cfq.messagerieUUID,
                                    users: cfq.users,
                                    timestamp: cfq.timestamp,
                                    participants: cfq.participants,
                                    userContact: userAdmin
                                )

                                coordinator.selectedConversation = Conversation(
                                    uid: cfq.messagerieUUID,
                                    titleConv: cfq.title,
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
                            }
                            .padding(.trailing, 12)
                        }
                    }
                }
            }
        }
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        // CFQCollectionView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
