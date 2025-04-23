
import Foundation
import SwiftUI

class TeamEditViewModel: ObservableObject {

    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var imageProfile: Image?
    
    @Published var uuidTeam = String()
    @Published var titleTeam = String()
    @Published var pictureUrlString = String()
    @Published var setFriends = Set<UserContact>()
    @Published var setAdmins = Set<UserContact>()
    @Published var showFriendsList: Bool = false

    @Published var allFriends = Set<UserContact>(
        [
            UserContact(
                uid: "77MKZdb3FJX8EFvlRGotntxk6oi1",
                name: "name1",
                firstName: "firstName1",
                pseudo: "pseudo1",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "EMZGTTeqJ1dv9SX0YaNOExaLjjw1",
                name: "name2",
                firstName: "firstName2",
                pseudo: "pseudo2",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "ziOs7jn3d5hZ0tgkTQdCNGQqlB33",
                name: "name3",
                firstName: "firstName3",
                pseudo: "pseudo3",
                profilePictureUrl: ""
            ),
        ]
    )

    var firebaseService = FirebaseService()
    
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: "",
        friends: ["EMZGTTeqJ1dv9SX0YaNOExaLjjw1", "77MKZdb3FJX8EFvlRGotntxk6oi1", "ziOs7jn3d5hZ0tgkTQdCNGQqlB33"]
    )

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
            firebaseService.updateDataByID(
                data: ["admins": adminsUUID, "title": titleTeam, "friends": friendsUUID],
                to: .teams,
                at: uuidTeam
            )
        } else {
            print("@@@ No send")
        }
    }
}

