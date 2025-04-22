
import Foundation
import SwiftUI

class TeamEditViewModel: ObservableObject {

    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    @Published var imageProfile: Image?
    
    @Published var uuidTeam = String()
    @Published var titleTeam = String()
    @Published var pictureUrlString = String()
    @Published var setFriends = Set<UserContact>()
    @Published var setAdmins = Set<UserContact>()

    var firebaseService = FirebaseService()
    
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

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

extension TeamEditViewModel {
    
    func pushEditTeamToFirebase(uuidTeam: String) {
        var friendsUUID = [String]()
        var adminsUUID = [String]()
        
        setFriends.forEach({
            friendsUUID.append($0.uid)
            print("@@@ friendsUUID = \($0.uid )")
        })
        
        setAdmins.forEach({
            adminsUUID.append($0.uid)
            print("@@@ adminsUUID = \($0.uid )")
        })

        firebaseService.updateDataByID(
            data: ["admins": adminsUUID, "title": titleTeam, "friends": friendsUUID],
            to: .teams,
            at: uuidTeam
        )
/*
        if titleTeam.isEmpty || !pictureUrlString.isEmpty || !friendsUUID.isEmpty || !adminsUUID.isEmpty {
            firebaseService.updateDataByID(
                data: ["title": titleTeam, "admins": adminsUUID, "friends": friendsUUID, "pictureUrlString": "pictureUrlString"],
                to: .teams,
                at: uuidTeam
            )
        } else {
            print("@@@ No send")
        }
 */
    }
}

