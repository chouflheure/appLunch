
import Foundation
import SwiftUI

class MessagerieScreenViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var showConversationOptionView: Bool = false
    @Published var messages: [Message] = []
    @Published var textMessage: String = ""

    private let firebaseService = FirebaseService()
    @ObservedObject var coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        fetchMessages()
        
    }
    
    deinit {
        firebaseService.removeListener(for: ListenerType.conversation.rawValue)
    }
}

extension MessagerieScreenViewModel {
    
    func fetchMessages() {

        guard let conversationID = coordinator.selectedConversation?.uid else {
            return
        }
        
        firebaseService.getMessagesByIds(
            conversationID: conversationID,
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
        
        firebaseService.markMessageAsRead(conversationId: conversationID, userId: coordinator.user?.uid ?? "")
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
    
        let message = Message (
            uid: UUID().description,
            message: textMessage,
            senderUID: coordinator.user?.uid ?? "",
            timestamp: Date(),
            userContact: UserContact(
                uid: coordinator.user?.uid ?? "",
                name: coordinator.user?.name ?? "",
                firstName: coordinator.user?.firstName ?? "",
                pseudo: coordinator.user?.pseudo ?? "",
                profilePictureUrl: coordinator.user?.profilePictureUrl ?? ""
            )
        )
        
        messages.append(message)
        
        firebaseService.addMessage(
            data: message,
            at: coordinator.selectedConversation?.uid ?? "",
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
            at: coordinator.selectedConversation?.uid ?? ""
        )
        
        textMessage = ""
    }
}

