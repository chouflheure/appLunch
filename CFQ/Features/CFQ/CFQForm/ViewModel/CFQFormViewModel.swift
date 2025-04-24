import Foundation

class CFQFormViewModel: ObservableObject {

    @Published var researchText = String()
    @Published var isEnableButton: Bool = false
    @Published var friendsList = Set<UserContact>()
    @Published var friendsAddToCFQ = Set<UserContact>()
    
    var user: User
    var firebaseService = FirebaseService()
    private var allFriends = Set<UserContact>()

    @Published var titleCFQ: String = "" {
        didSet {
            isEnableButton = !titleCFQ.isEmpty
        }
    }

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init(coordinator: Coordinator, user: User) {
        self.user = user
        friendsList = Set(coordinator.userFriends)
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
        
        let uuid = UUID()
        let messagerieUUID = UUID()
        var adminUUIDs = [""]

        firebaseService.addData(
            data: CFQ(
                uid: uuid.description,
                title: titleCFQ,
                admin: user.uid,
                messagerieUUID: messagerieUUID.description,
                users: adminUUIDs
            ),
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
