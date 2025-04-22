
import Foundation
import FirebaseFirestore

class TeamListScreenViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    @Published var teams = [Team]()
    @Published var teamsGlobal = [TeamGlobal(uid: "", title: "", pictureUrlString: "", friends: [UserContact()], admins: [UserContact()])]

    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"],
        teams: ["1"]
    )

    init() {
        startListeningToTeams()
    }

    func startListeningToTeams() {
        firebaseService.getDataByIDs(
            from: .teams,
            with: user.teams ?? [""],
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
        ){ (result: Result<[Team], Error>) in
                switch result {
                case .success(let teams):
                    self.teams = teams

                    teams.indices.forEach { index in
                        self.startListeningToUsersOnTeam(friendsIds: teams[index].friends, uidTeam: teams[index].uid) { data, error in
                            if !data.isEmpty {
                                if index >= self.teamsGlobal.count {
                                    self.teamsGlobal.append(teams[index].toTeamGlobal())
                                } else {
                                    self.teamsGlobal[index] = teams[index].toTeamGlobal()
                                }

                                self.teamsGlobal[index].friends = data

                                let uuidSet = Set(teams[index].admins)
                                // Filtrer les objets pour ne conserver que ceux dont l'UUID est dans l'ensemble
                                let commonObjects = data.filter { uuidSet.contains($0.uid) }
                                self.teamsGlobal[index].admins = commonObjects

                            } else {
                                print("@@@ data NOOOO")
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
            listenerKeyPrefix: (ListenerType.team_user.rawValue + "\(uidTeam)")
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
