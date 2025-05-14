
import Foundation

class FeedViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    var turnsID = ["FP5UQvLXVpuSt8N0b9ML", "9BB80E71-84B3-4503-90E8-470836A22FB7", "DC77FECA-B535-4CBF-81F7-C9D09FA32049", "F2D2CE38-0C1E-44E7-ABFA-FF9C588676CB"]
    @Published var turns: [Turn] = []
        
    // TODO: - Mettre turnsID en set car si deux fois le même ca bug

    init() {
        startListeningToTeams()
    }

    func startListeningToTeams() {
        firebaseService.getDataByIDs(
            from: .turns,
            with: turnsID,
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
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
                    var updatedTurns = self.turns
                    updatedTurns[index].adminContact = adminContact
                    
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    self.turns = updatedTurns
                    
                    print("@@@ Admin récupéré pour le turn \(index)")
                    print("@@@ turn.adminContact = \(adminContact.pseudo)")
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
