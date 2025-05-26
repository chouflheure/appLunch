
import Foundation
import Firebase
import SwiftUI

class PreviewMessagerieScreenViewModel: ObservableObject {
    
    @Published var researchText = String()
    @Published var messageList = [Conversation]()
    @ObservedObject var coordinator: Coordinator
 
    private var firebaseService = FirebaseService()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        fectchMessagesPreview()
    }
}

extension PreviewMessagerieScreenViewModel {
    
    func fectchMessagesPreview() {
        print("fetch conv ")
        print("@@@ coordinator.user?.messagesChannelId = \(coordinator.user?.messagesChannelId)")
        firebaseService.getDataByIDs(
            from: .conversations,
            with: coordinator.user?.messagesChannelId ?? [],
            listenerKeyPrefix: ListenerType.conversation.rawValue
        ) { [weak self] (result: Result<[Conversation], Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let fetchedConv):
                DispatchQueue.main.async {
                    self?.messageList = fetchedConv
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
