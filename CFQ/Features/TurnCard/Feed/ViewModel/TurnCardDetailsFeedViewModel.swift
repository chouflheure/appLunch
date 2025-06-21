
import Foundation

class TurnCardDetailsFeedViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    @Published var turn: Turn

    init(turn: Turn) {
        self.turn = turn
        
        if turn.titleEvent.isEmpty {
            getTurnData(turnUID: turn.uid)
        }
    }
    
    func getTurnData(turnUID: String) {
        firebaseService.getDataByID(from: .turns, with: turnUID) { [weak self] (result: Result<Turn, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let turn):
                DispatchQueue.main.async {
                    self.turn = turn
                    print("@@@ turn = \(turn.printObject)")
                    self.fetchUserContactturn(adminID: turn.admin)
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
    
    private func fetchUserContactturn(adminID: String) {
        firebaseService.getDataByID(from: .users, with: adminID) { [weak self] (result: Result<UserContact, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let userContact):
                DispatchQueue.main.async {
                    self.turn.adminContact = userContact
                    print("@@@ userContact = \(userContact.printObject)")
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
