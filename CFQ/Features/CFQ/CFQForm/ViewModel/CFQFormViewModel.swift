import Foundation

class CFQFormViewModel: ObservableObject {

    @Published var researchText = String()
    @Published var friendsList = Set<UserContact>()
    @Published var friendsAddToCFQ = Set<UserContact>()
    
    var user: User
    var firebaseService = FirebaseService()
    private var allFriends = Set<UserContact>()

    @Published var titleCFQ: String = ""

    var isEnableButton: Bool {
        get {
            !friendsAddToCFQ.isEmpty && !titleCFQ.isEmpty
        }
        set {}
    }
    
    var filteredNames: Set<UserContact> {
        let searchWords = researchText.split(separator: " ").map { $0.lowercased() }
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init(coordinator: Coordinator) {
        self.user = coordinator.user ?? User(uid: "")
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
        var adminUUIDs = [String]()
        
        friendsAddToCFQ.forEach({ adminUUIDs.append($0.uid) })

        firebaseService.addData(
            data: CFQ(
                uid: uuid.description,
                title: "CFQ " + titleCFQ + " ?",
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
