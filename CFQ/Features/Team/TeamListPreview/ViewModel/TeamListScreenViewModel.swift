
import Foundation
import FirebaseFirestore

class TeamListScreenViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    // @Published var teams = [Team]()
    var user: User
    
    @Published private var _teams: [Team] = []
    
    var teams: [Team] {
        return _teams.sorted { $0.timestamp > $1.timestamp }
    }
    
    func addTeam(_ team: Team) {
        _teams.append(team)
    }
    
    func updateTeams(_ teams: [Team]) {
        _teams = teams
    }
    
    init(coordinator: Coordinator) {
        self.user = coordinator.user ?? User(uid: "")
    }

    func refreshTeams() {
        // Arrêter les anciens listeners pour éviter les doublons
        firebaseService.removeListener(for: ListenerType.team_group_listener.rawValue)
        
        // Vider la liste actuelle
        _teams.removeAll()
        
        // Relancer l'écoute
        startListeningToTeams()
    }
    
    func startListeningToTeams() {
        print("@@@ here")
        firebaseService.getDataByIDs(
            from: .teams,
            with: user.teams ?? []
        ){ (result: Result<[Team], Error>) in
                switch result {
                case .success(let teams):
                    DispatchQueue.main.async {
                        self._teams = teams
                        teams.forEach { team in
                            self.startListeningToUsersOnTeam(friendsIds: team.friends, uidTeam: team.uid) { data, error in
                                DispatchQueue.main.async {
                                    // ✅ Trouver l'équipe par son UID au lieu d'utiliser l'index
                                    guard let teamIndex = self._teams.firstIndex(where: { $0.uid == team.uid }) else {
                                        print("⚠️ Team avec UID \(team.uid) non trouvée dans self.teams")
                                        return
                                    }
                                    
                                    if !data.isEmpty {
                                        self._teams[teamIndex].friendsContact = data
                                        
                                        let uuidSet = Set(team.admins)
                                        let commonObjects = data.filter { uuidSet.contains($0.uid) }
                                        self._teams[teamIndex].adminsContact = commonObjects
                                    } else {
                                        print("@@@ data NOOOO")
                                    }
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
