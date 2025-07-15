import Foundation
import SwiftUI


// TODO: -
// - Fuction remove user team
// - Fuction remove picture change
// - Function quitte team

class TeamEditViewModel: ObservableObject {

    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var imageProfile: UIImage?

    @Published var uuidTeam: String
    @Published var titleTeam: String
    @Published var pictureUrlString = String()
    @Published var setFriends = Set<UserContact>()
    @Published var setAdmins = Set<UserContact>()

    @Published var allFriends = Set<UserContact>()

    @EnvironmentObject var user: User
    @ObservedObject var team: Team

    private var firebaseService = FirebaseService()

    var isEnableButton: Bool {
        return !titleTeam.isEmpty || !pictureUrlString.isEmpty
        || !setAdmins.isEmpty || !setFriends.isEmpty || !setFriends.isEmpty
    }
    
    init(team: Team, allFriends: [UserContact]?) {
        self.team = team
        
        self.uuidTeam = team.uid
        titleTeam = team.title
        
        setFriends = Set(team.friendsContact ?? [UserContact()])
        setAdmins = Set(team.adminsContact ?? [UserContact()])
        
        allFriends?.forEach { friend in
            if !setFriends.contains(friend) {
                self.allFriends.insert(friend)
            }
        }
    }

}

extension TeamEditViewModel {

    func pushEditTeamToFirebase(
        uuidTeam: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        var friendsUUID = [String]()
        var adminsUUID = [String]()

        setFriends.forEach({
            friendsUUID.append($0.uid)
        })

        setAdmins.forEach({
            adminsUUID.append($0.uid)
        })

        var data = [String: Any]()

        if !titleTeam.isEmpty {
            data["title"] = titleTeam
        }

        if !friendsUUID.isEmpty {
            data["friends"] = friendsUUID
        }

        if !adminsUUID.isEmpty {
            data["admins"] = adminsUUID
        }

        if let image = imageProfile {
            firebaseService.uploadImageStandard(
                picture: image,
                uidUser: uuidTeam,
                localisationImage: .team,
                completion: { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let urlString):
                            data["pictureUrlString"] = urlString
                            self.firebaseService.updateDataByID(
                                data: data,
                                to: .teams,
                                at: uuidTeam
                            ) { result in
                                switch result {
                                case .success():
                                    completion(true, "")
                                case .failure(let error):
                                    completion(
                                        false,
                                        error.localizedDescription
                                    )
                                }
                            }

                        case .failure(let error):
                            Logger.log(
                                error.localizedDescription,
                                level: .error
                            )
                        }
                    }
                }
            )
        } else {
            firebaseService.updateDataByID(
                data: data,
                to: .teams,
                at: uuidTeam
            ) { result in
                switch result {
                case .success():
                    completion(true, "")
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }
            }
        }

    }
}
