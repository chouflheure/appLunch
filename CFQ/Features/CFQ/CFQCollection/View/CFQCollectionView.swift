
import SwiftUI
import FirebaseFirestore
import Lottie

struct CFQCollectionView: View {
    @ObservedObject var coordinator: Coordinator
    @State var showDetail: Bool = false

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
                    ForEach(coordinator.userCFQ, id: \.uid) { cfq in
                        // ?? 
                        if let userAdmin = coordinator.userFriends.first(where: { $0.uid == cfq.admin }) {
                            CFQMolecule(
                                name: userAdmin.pseudo,
                                title: cfq.title,
                                image: userAdmin.profilePictureUrl
                            )
                            .onTapGesture {
                                coordinator.selectedConversation = Conversation(
                                    uid: cfq.messagerieUUID,
                                    titleConv: "",
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
