
import Foundation
import SwiftUI

class MessagerieScreenViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var showConversationOptionView: Bool = false
    @Published var messages: [Message] = []

    private let firebaseService = FirebaseService()
    @ObservedObject var coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        fectchMessages()
        
    }

    @Published var textMessage: String = ""
 
    /*
     Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ")
     */
}

extension MessagerieScreenViewModel {
    
    func fectchMessages() {
        firebaseService.getMessagesByIds(
            conversationID: coordinator.selectedConversation?.uid ?? "",
            with: coordinator.selectedConversation?.messagesArrayUID ?? [],
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
        ) { [weak self] (result: Result<[Message], Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let messages):
                
                DispatchQueue.main.async {
                    messages.forEach({
                        print("@@@ \(String(describing: $0.printObject))")
                    })
                    
                    self?.messages = messages
                    
                    for (index, messages) in messages.enumerated() {
                        self?.fetchUserContactMessages(at: index, adminID: messages.senderUID)
                    }
                    
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error = \(error)")
            }
        }
    }
    
    func fetchUserContactMessages(at index: Int, adminID: String) {
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
                    print("@@@ userMessage = \(userMessage)")
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    self.messages = updatedMessageUser
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
