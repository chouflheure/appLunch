import Foundation
import SwiftUI
import Firebase

class TeamDetailViewModel: ObservableObject {
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    @ObservedObject var coordinator: Coordinator

    var firebaseService = FirebaseService()

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func isAdmin(userUUID: String, admins: [UserContact]?) -> Bool {
        var adminsUUID = [String]()
        guard let admins = admins else { return false }

        admins.forEach({
            adminsUUID.append($0.uid)
        })

        return adminsUUID.contains(userUUID)
    }
    
    func leaveTeam(team: Team, userUUID: String) {
        
        if team.admins.count == 1 && team.admins.contains(userUUID) {
            removeTeam(team: team, completion: {_, _ in})
        } else {
            firebaseService.updateDataByID(
                data: ["teams": FieldValue.arrayRemove([team.uid])],
                to: .users,
                at: userUUID
            )
            
            firebaseService.updateDataByID(
                data: [
                    "admins": FieldValue.arrayRemove([userUUID]),
                    "friends": FieldValue.arrayRemove([userUUID])
                ],
                to: .teams,
                at: team.uid
            )
            
            self.coordinator.user?.teams?.removeAll(where: {$0 == team.uid})
        }
    }
    
    func removeTeam(team: Team, completion: @escaping (Bool, String) -> Void) {
        firebaseService.deleteDataByID(
            from: .teams,
            at: team.uid,
            completion: { result in
                switch result {
                case .success(()):
                    self.coordinator.user?.teams?.removeAll(where: {$0 == team.uid})
                    self.removeTeamForUsers(team: team)

                    completion(true, "")
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            })
    }
    
    private func removeTeamForUsers(team: Team) {
        firebaseService.updateDataByIDs(
            data: ["teams": FieldValue.arrayRemove([team.uid])],
            to: .users,
            at: team.friends
        )
    }
    
    func titleError(error: Error) -> String {
        
        return "Error"
    }
}
