
import Foundation
import SwiftUI

class FeedViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    @Published var cfq = [CFQ]()
    @Published var turns = [Turn]()
    @ObservedObject var coordinator: Coordinator
    
    var turnsID = ["FP5UQvLXVpuSt8N0b9ML", "9BB80E71-84B3-4503-90E8-470836A22FB7", "DC77FECA-B535-4CBF-81F7-C9D09FA32049", "F2D2CE38-0C1E-44E7-ABFA-FF9C588676CB"]
    
    // TODO: - Mettre turnsID en set car si deux fois le même ca bug

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        guard let user = coordinator.user else {
            print("@@@ else")
            return
        }
        startListeningToTurn(user: user)
        catchAllUserCFQ(user: user)
    }
    
    func catchAllUserCFQ(user: User) {
        // user.invitedCfqs = removeEmptyIdInArray(data: user.invitedCfqs ?? [""])
        if let invitedCfqs = user.invitedCfqs, !invitedCfqs.isEmpty {
            firebaseService.getDataByIDs(
                from: .cfqs,
                with: invitedCfqs,
                listenerKeyPrefix: ListenerType.cfq.rawValue
            ){ (result: Result<[CFQ], Error>) in
                switch result {
                case .success(let cfq):
                    DispatchQueue.main.async {
                        self.coordinator.userCFQ = cfq
                        // self.cfq = cfq
                        cfq.forEach { (item) in
                        }
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")
                    
                }
            }
        }
    }
    
    func startListeningToTurn(user: User) {
        firebaseService.getDataByIDs(
            from: .turns,
            with: user.invitedTurns ?? [""],
            listenerKeyPrefix: ListenerType.turn.rawValue
        ) { [weak self] (result: Result<[Turn], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let fetchedTurns):
                // Stockez les turns récupérés
                DispatchQueue.main.async {
                    self.turns = fetchedTurns
                    
                    // Pour chaque turn, récupérez l'admin
                    for (index, turn) in fetchedTurns.enumerated() {
                        self.fetchAdminForTurn(at: index, adminID: turn.admin)
                    }
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error")
            }
        }
    }

    func fetchAdminForTurn(at index: Int, adminID: String) {
        firebaseService.getDataByID(from: .users, with: adminID) { [weak self] (result: Result<UserContact, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let adminContact):
                // Assurez-vous que l'index est toujours valide
                guard index < self.turns.count else { return }
                
                // Important: Sur le thread principal pour les UI updates
                DispatchQueue.main.async {
                    // Créez une copie du tableau entier pour déclencher le changement observable
                    let updatedTurns = self.turns
                    updatedTurns[index].adminContact = adminContact
                    
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    self.turns = updatedTurns
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
