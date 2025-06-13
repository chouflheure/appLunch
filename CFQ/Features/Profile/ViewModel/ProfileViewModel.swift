
import Foundation
import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var isShowingSettingsView: Bool = false
    @Published var turns = [Turn]()
    var user: User
    @ObservedObject var coordinator: Coordinator

    var firebaseService = FirebaseService()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        guard let user = coordinator.user else {
            self.user = User()
            return
        }
        self.user = user
        startListeningToTurn(user: self.user)
    }
    
    func startListeningToTurn(user: User) {
        firebaseService.getDataByIDs(
            from: .turns,
            with: user.postedTurns ?? [""],
            listenerKeyPrefix: ListenerType.turn.rawValue
        ) { [weak self] (result: Result<[Turn], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedTurns):
                // Stockez les turns récupérés
                DispatchQueue.main.async {
                    self.turns = fetchedTurns
                    self.turns.forEach({ turn in
                        turn.adminContact = UserContact(
                            uid: user.uid,
                            name: user.uid,
                            pseudo: user.pseudo,
                            profilePictureUrl: user.profilePictureUrl,
                            isActive: user.isActive
                        )
                    })
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error")
            }
        }
    }
}
