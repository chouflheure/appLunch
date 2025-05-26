
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
        firebaseService.getDataByIDs(
            from: .conversations,
            with: coordinator.user?.messagesChannelId ?? [],
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
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
