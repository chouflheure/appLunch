import Foundation

class CFQFormViewModel: ObservableObject {
    // @Published var titleCFQ = String()
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var showSheetAddFriend: Bool = false
    @Published var friendsList = Set<UserContact>()
    private var allFriends = Set<UserContact>()

    var firebaseService = FirebaseService()

    @Published var titleCFQ: String = "" {
        didSet {
            isEnableButton = !titleCFQ.isEmpty
        }
    }

    @Published var isEnableButton: Bool = false

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1",
        name: "Charles",
        firstName: "Charles",
        pseudo: "Charles",
        profilePictureUrl: ""
    )

    @Published var friendsAddToCFQ = Set<UserContact>(
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

    @Published var friendsListTest = Set<UserContact>(
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


    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init(coordinator: Coordinator) {
        // friendsList = Set(coordinator.userFriends)
        allFriends = friendsList
    }

    func removeFriendsFromList(user: UserContact) {
        friendsAddToCFQ.remove(user)
        friendsList.insert(user)
        allFriends.insert(user)
    }

    func addFriendsToList(user: UserContact) {
        friendsAddToCFQ.insert(user)
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

extension CFQFormViewModel {

    func pushCFQ() {
        print("@@@ val = \(isEnableButton)")
        let uuid = UUID()

        firebaseService.addData(
            data: CFQ(
                uid: uuid.description, title: titleCFQ, admin: user.pseudo,
                messagerieUUID: "", users: [""]),
            to: .cfqs,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )

    }
}
