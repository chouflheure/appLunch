
import Foundation

class PreviewMessagerieScreenViewModel: ObservableObject {
    @Published var titleCFQ = String()
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    
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
    @Published var messageList = [MessageCellModel] (
        [
            MessageCellModel(
                uid: "1",
                titleConversation: "Charles",
                messagePreview: "Coucou",
                time: "4min",
                hasUnReadMessage: true
            ),
            
            MessageCellModel(
                uid: "2",
                titleConversation: "CFQ Demain",
                messagePreview: "Coucou",
                time: "10min",
                hasUnReadMessage: false
            ),
            
            MessageCellModel(
                uid: "3",
                titleConversation: "CFQ Jeudi",
                messagePreview: "Coucou",
                time: "13min",
                hasUnReadMessage: true
            ),
            
            MessageCellModel(
                uid: "4",
                titleConversation: "CFQ caca",
                messagePreview: "Coucou",
                time: "14min",
                hasUnReadMessage: false
            ),
            
            MessageCellModel(
                uid: "5",
                titleConversation: "Lisa",
                messagePreview: "Coucou mon chat",
                time: "24min",
                hasUnReadMessage: false
            ),
            
            MessageCellModel(
                uid: "6",
                titleConversation: "Luis",
                messagePreview: "Salut poulet !",
                time: "4min",
                hasUnReadMessage: true
            )
        ]
    )

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
        // allFriends = messageList
    }
    
    func removeFriendsFromList(user: UserContact) {
        friendsAdd.remove(user)
        // messageList.insert(user)
        allFriends.insert(user)
    }

    func addFriendsToList(user: UserContact) {
        friendsAdd.insert(user)
        // messageList.remove(user)
        allFriends.remove(user)
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        // messageList = allFriends
        // messageList = filteredNames
    }
}
