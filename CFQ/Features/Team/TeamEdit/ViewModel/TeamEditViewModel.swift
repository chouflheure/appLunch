
import Foundation
import SwiftUI

class TeamEditViewModel: ObservableObject {

    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var imageProfile: UIImage?
    
    @Published var uuidTeam = String()
    @Published var titleTeam = String()
    @Published var pictureUrlString = String()
    @Published var setFriends = Set<UserContact>()
    @Published var setAdmins = Set<UserContact>()
    @Published var showFriendsList: Bool = false

    @Published var allFriends = Set<UserContact>()

    var firebaseService = FirebaseService()
    @EnvironmentObject var user: User

}

extension TeamEditViewModel {

    func listFriendsOnTeamAndToAdd() {
        firebaseService.getDataByIDs(
            from: .users,
            with: user.friends,
            onUpdate: {(result: Result<[UserContact], Error>) in
                switch result {
                case .success(let friends):
                    self.allFriends = Set(friends)
                    print("@@@ friends= \n\(friends)")
                case .failure(let error):
                    print("@@@ error = \n\(error)")
                }
            }
        )
    }

    func pushEditTeamToFirebase(uuidTeam: String) {
        var friendsUUID = [String]()
        var adminsUUID = [String]()
        
        
        setFriends.forEach({
            friendsUUID.append($0.uid)
        })
        
        setAdmins.forEach({
            adminsUUID.append($0.uid)
       })

        if !titleTeam.isEmpty || !pictureUrlString.isEmpty || !friendsUUID.isEmpty || !adminsUUID.isEmpty {
            if let image = imageProfile {
                firebaseService.uploadImageStandard(
                    picture: imageProfile ?? UIImage(),
                    uidUser: uuidTeam,
                    localisationImage: .team,
                    completion: { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let urlString):
                                print("@@@ urlString = \(urlString)")
                                self.firebaseService.updateDataByID(
                                    data: ["admins": adminsUUID, "title": self.titleTeam, "friends": friendsUUID, "imageProfile": urlString],
                                    to: .teams,
                                    at: uuidTeam
                                )

                            case .failure(let error):
                                Logger.log(error.localizedDescription, level: .error)
                            }
                        }
                    }
                )
            } else {
                firebaseService.updateDataByID(
                    data: ["admins": adminsUUID, "title": titleTeam, "friends": friendsUUID],
                    to: .teams,
                    at: uuidTeam
                )
            }
        } else {
            print("@@@ No send")
        }
    }
}

