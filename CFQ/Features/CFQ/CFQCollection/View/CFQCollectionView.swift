
import SwiftUI
import FirebaseFirestore
import Lottie

struct CFQCollectionView: View {
    @ObservedObject var coordinator: Coordinator
    @EnvironmentObject var user: User

    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 30) {
                    NavigationLink(
                        destination: CFQFormView(coordinator: coordinator)
                    ) {
                        Image(.iconPlus)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                    }

                    ForEach(coordinator.userCFQ.sorted(by: { $0.timestamp > $1.timestamp }), id: \.uid) { cfq in
                        
                        NavigationLink(
                            destination: MessagerieView(
                                coordinator: coordinator,
                                conversation: Conversation(
                                    uid: cfq.messagerieUUID,
                                    titleConv: cfq.title,
                                    pictureEventURL: userAdmin(cfq: cfq).profilePictureUrl,
                                    typeEvent: "cfq",
                                    eventUID: cfq.uid,
                                    lastMessageSender: "",
                                    lastMessageDate: Date(),
                                    lastMessage: "",
                                    messageReader: []
                                ),
                                cfq: CFQ(
                                    uid: cfq.uid,
                                    title: cfq.title,
                                    admin: cfq.admin,
                                    messagerieUUID: cfq.messagerieUUID,
                                    users: cfq.users,
                                    timestamp: cfq.timestamp,
                                    participants: cfq.participants,
                                    userContact: userAdmin(cfq: cfq)
                                )
                            )
                        ) {
                            CFQMolecule(
                                uid: cfq.uid,
                                name: userAdmin(cfq: cfq).pseudo,
                                title: cfq.title,
                                image: userAdmin(cfq: cfq).profilePictureUrl
                            )
                        }
                        .padding(.trailing, 12)
                    }
                }
            }
        }
    }
    
    func userAdmin(cfq: CFQ) -> UserContact {
        if cfq.admin == user.uid {
            return UserContact(uid: user.uid, pseudo: user.pseudo, profilePictureUrl: user.profilePictureUrl)
        }
        if let admin = user.userFriendsContact?.first(where: { $0.uid == cfq.admin }) {
            return admin
        }
        return UserContact()
    }
}


#Preview {
    ZStack {
        NeonBackgroundImage()
        // CFQCollectionView(coordinator: Coordinator())
    }.ignoresSafeArea()
}
