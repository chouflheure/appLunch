import Foundation
import SwiftUI

class TeamFormViewModel: ObservableObject {
    @Published var nameTeam = String()
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    @Published var team: Team?
    @Published var imageProfile: Image?

    var firebaseService = FirebaseService()
    

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )
    
    let userContact: UserContact

    var isUserAdmin: Bool {
        get {
            adminList.contains(userContact)
        }
        set {}
    }

    @Published var adminList = Set<UserContact>(
        [
            UserContact(
                uid: "1",
                name: "Charles",
                firstName: "Charles",
                pseudo: "Charles",
                profilePictureUrl: ""
            )
        ]
    )

    @Published var friendsAdd = Set<UserContact>(
        [
            UserContact(
                uid: "1",
                name: "Charles",
                firstName: "Charles",
                pseudo: "Charles",
                profilePictureUrl: ""
            )
        ]
    )

    @Published var friendsList = Set<UserContact>(
        [
            UserContact(
                uid: "1",
                name: "Charles",
                firstName: "Charles",
                pseudo: "Charles",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "2",
                name: "Lisa",
                firstName: "Lisa",
                pseudo: "Lisa",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "3",
                name: "Thibault",
                firstName: "Thibault",
                pseudo: "Thibault",
                profilePictureUrl: ""
            ),

            UserContact(
                uid: "4",
                name: "Nanou",
                firstName: "Nanou",
                pseudo: "Nanou",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "5",
                name: "Clemence",
                firstName: "Clemence",
                pseudo: "Clemence",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "6",
                name: "Nil",
                firstName: "Nil",
                pseudo: "Nil",
                profilePictureUrl: ""
            ),
        ]
    )

    @Published var showFriendsList: Bool = false
    private var allFriends = Set<UserContact>()

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init() {
        userContact = UserContact(
            uid: user.uid,
            name: user.name,
            firstName: user.firstName,
            pseudo: user.pseudo,
            profilePictureUrl: user.profilePictureUrl
        )
        allFriends = friendsList
        
    }
    
    func removeFriendsFromList(user: UserContact) {
        friendsAdd.remove(user)
        friendsList.insert(user)
        allFriends.insert(user)
    }

    func addFriendsToList(user: UserContact) {
        friendsAdd.insert(user)
        friendsList.remove(user)
        allFriends.remove(user)
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        friendsList = allFriends
        friendsList = filteredNames
    }
}

// firebase functions
extension TeamFormViewModel {
    
    func pushNewTeamToFirebase() {
        let uuid = UUID()
        print("@@@ uuid = \(uuid.description)")
        let team = Team (
            uid: uuid.description,
            title: nameTeam,
            pictureUrlString: "",
            friends: Array(friendsAdd),
            admins: "string"
        )

        firebaseService.addData(data: team, to: .teams) { (result: Result<Void, Error>) in
            switch result{
            case .success():
                print("@@@ success")
            case .failure(let error):
                print("@@@ error = \(error)")
            }
        }
    }
}
