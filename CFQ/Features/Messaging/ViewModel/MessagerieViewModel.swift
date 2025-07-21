
import Foundation
import SwiftUI

class MessagerieViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var showConversationOptionView: Bool = false
    @Published var messages: [Message] = []
    @Published var textMessage: String = ""
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var conversation: Conversation

    private let firebaseService = FirebaseService()

    init(coordinator: Coordinator, conversation: Conversation) {
        self.coordinator = coordinator
        self.conversation = conversation
        fetchMessages()
    }

    deinit {
        firebaseService.removeListener(for: ListenerType.conversation.rawValue)
    }
}

extension MessagerieViewModel {
    
    func fetchMessages() {
        firebaseService.getMessagesByIds(
            conversationID: conversation.uid,
            limit: 15,
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
        ) { [weak self] (result: Result<[Message], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let messages):
                DispatchQueue.main.async {
                    self.messages = messages

                    // Fetch user contact pour chaque message
                    for (index, message) in messages.enumerated() {
                        self.fetchUserContactMessages(at: index, adminID: message.senderUID)
                    }
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error = \(error)")
            }
        }
        markMessageAsRead()
    }
    
    func markMessageAsRead() {
        firebaseService.markMessageAsRead(conversationId: conversation.uid, userId: coordinator.user?.uid ?? "")
    }
    
    private func fetchUserContactMessages(at index: Int, adminID: String) {
        firebaseService.getDataByID(from: .users, with: adminID) { [weak self] (result: Result<UserContact, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userMessage):
                // Assurez-vous que l'index est toujours valide
                guard index < self.messages.count else { return }
                
                // Important: Sur le thread principal pour les UI updates
                DispatchQueue.main.async {
                    // Créez une copie du tableau entier pour déclencher le changement observable
                    let updatedMessageUser = self.messages
                    updatedMessageUser[index].userContact = userMessage
                    // print("@@@ userMessage = \(userMessage)")
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    self.messages = updatedMessageUser
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
    
    func pushMessage() {
    
        if textMessage.last == "\n" {
            textMessage.removeLast()
        }

        let message = Message (
            uid: UUID().description,
            message: textMessage,
            senderUID: coordinator.user?.uid ?? "",
            timestamp: Date(),
            userContact: UserContact(
                uid: coordinator.user?.uid ?? "",
                name: coordinator.user?.name ?? "",
                pseudo: coordinator.user?.pseudo ?? "",
                profilePictureUrl: coordinator.user?.profilePictureUrl ?? ""
            )
        )
        
        messages.append(message)
        
        firebaseService.addMessage(
            data: message,
            at: conversation.uid,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )

        firebaseService.updateDataByID(
            data: [
                "lastMessageSender": message.userContact?.pseudo ?? "",
                "lastMessageDate": Date(),
                "lastMessage": message.message,
                "messageReader": [coordinator.user?.uid ?? ""]
            ],
            to: .conversations,
            at: conversation.uid
        )
        
        textMessage = ""
    }
}

