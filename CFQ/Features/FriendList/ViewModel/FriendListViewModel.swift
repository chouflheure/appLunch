
import Foundation

class FriendListViewModel: ObservableObject {
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false

    var firebaseService = FirebaseService()
    
    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

    @Published var friendsList = Set<UserContact>()

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

    
    init(coordinator: Coordinator) {
        friendsList = Set(coordinator.userFriends)
        allFriends = friendsList
    }
    
    func removeFriendsFromList(user: UserContact) {
        friendsList.insert(user)
        allFriends.insert(user)
    }

    func addFriendsToList(user: UserContact) {
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

extension FriendListViewModel {
    
    func removeFriend(user: UserContact) {
        // TODO: do remove element by id dans une ligne particulière
    }
}
