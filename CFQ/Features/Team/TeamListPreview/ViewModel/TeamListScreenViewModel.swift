
import Foundation
import FirebaseFirestore

class TeamListScreenViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    @Published var teams = [Team]()
    var user: User
    
    init(coordinator: Coordinator) {
        self.user = coordinator.user ?? User(uid: "")
    }

    func refreshTeams() {
        // Arrêter les anciens listeners pour éviter les doublons
        firebaseService.removeListener(for: ListenerType.team_group_listener.rawValue)
        
        // Vider la liste actuelle
        teams.removeAll()
        
        // Relancer l'écoute
        startListeningToTeams()
    }
    
    func startListeningToTeams() {
        print("@@@ here")
        firebaseService.getDataByIDs(
            from: .teams,
            with: user.teams ?? [""],
        ){ (result: Result<[Team], Error>) in
                switch result {
                case .success(let teams):
                    DispatchQueue.main.async {
                        self.teams = teams
                        teams.indices.forEach { index in
                            self.startListeningToUsersOnTeam(friendsIds: teams[index].friends, uidTeam: teams[index].uid) { data, error in
                                if !data.isEmpty {
                                    self.teams[index].friendsContact = data
                                    
                                    let uuidSet = Set(teams[index].admins)
                                    // Filtrer les objets pour ne conserver que ceux dont l'UUID est dans l'ensemble
                                    let commonObjects = data.filter { uuidSet.contains($0.uid) }
                                    self.teams[index].adminsContact = commonObjects
                                    
                                } else {
                                    print("@@@ data NOOOO")
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("@@@ here")
                    print("❌ Erreur : \(error.localizedDescription)")
                }
            }
    }

    private func startListeningToUsersOnTeam(friendsIds: [String], uidTeam: String, completion: @escaping ([UserContact], Error?) -> Void) {
        firebaseService.getDataByIDs(
            from: .users,
            with: friendsIds,
        ){ (result: Result<[UserContact], Error>) in
            switch result {
                case .success(let userContact):
                    DispatchQueue.main.async {
                        completion(userContact, nil)
                    }
                case .failure(let error):
                    print("👎 Erreur : \(error.localizedDescription)")

                }
            }
    }
}
