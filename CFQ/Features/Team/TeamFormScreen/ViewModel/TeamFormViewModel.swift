import Foundation

class TeamFormViewModel: ObservableObject {
    @Published var nameTeam = String()
    @Published var friendsAdd = Set<UserContact>(
        [
            UserContact(
                uid: "1",
                name: "Charles",
                firstName: "Charles",
                username: "Charles",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "2",
                name: "Lisa",
                firstName: "Lisa",
                username: "Lisa",
                profilePictureUrl: ""
            ),
            UserContact(
                uid: "3",
                name: "Thibault",
                firstName: "Thibault",
                username: "Thibault",
                profilePictureUrl: ""
            ),
        ]
    )

    @Published var friendsList = Set<UserContact>(
        [
        UserContact(
            uid: "4",
            name: "Charles",
            firstName: "Charles",
            username: "Charles",
            profilePictureUrl: ""
        ),
        UserContact(
            uid: "5",
            name: "Lisa",
            firstName: "Lisa",
            username: "Lisa",
            profilePictureUrl: ""
        ),
        UserContact(
            uid: "6",
            name: "Thibault",
            firstName: "Thibault",
            username: "Thibault",
            profilePictureUrl: ""
        ),
    ]
    )

    @Published var showFriendsList: Bool = false

    func removeFriendsFromList(user: UserContact) {
        friendsAdd.remove(user)
        friendsList.insert(user)
    }

    func addFriendsToList(user: UserContact) {
        friendsAdd.insert(user)
        friendsList.remove(user)
    }
}
