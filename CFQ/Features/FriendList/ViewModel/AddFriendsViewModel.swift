
import Foundation
import SwiftUI

class AddFriendsViewModel: ObservableObject {
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var showFriendsList: Bool = false
    @ObservedObject var coordinator: Coordinator

    var firebaseService = FirebaseService()
    var user: User
    private var allFriends = Set<UserContact>()

    
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

    @Published var friendsList = Set<UserContact>()

    var filteredNames: Set<UserContact> {
        let searchWords = researchText.lowercased().split(separator: " ")
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.pseudo.lowercased().hasPrefix(word) || name.name.lowercased().hasPrefix(word)
            }
        }
    }

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        guard let user = coordinator.user else {
            self.user = User()
            return
        }
        self.user = user

        fecthAllUsers()
    }

    func removeText() {
        researchText.removeAll()
    }

    func researche() {
        friendsList = allFriends
        friendsList = filteredNames
    }
}

extension AddFriendsViewModel {
    
    func fecthAllUsers() {
        firebaseService.getAllData(from: .users) { (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                self.friendsList = Set(users)
                self.allFriends = Set(users)
                // completion(users)
            case .failure(let error):
                print("- Erreur :", error.localizedDescription)
            }
        }
    }
    
    func addFriendsToList(userFriend: UserContact) {
        firebaseService.updateDataByID(
            data: ["requestsFriends": user.uid],
            to: .users,
            at: userFriend.uid
        )

        let uidNotification = UUID()

        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .friendRequest,
                timestamp: Date(),
                uidUserNotif: userFriend.uid,
                uidEvent: "",
                titleEvent: "Become friends",
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: ["JtISdWec8JV4Od1WszEGXkqEVAI2"],
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes conv ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }

                
            }
        )
        
    }
    /*
    func cancelFriendsToList(userFriend: UserContact) {
        firebaseService.addData(
            data: <#T##Decodable & Encodable#>,
            to: <#T##CollectionFirebaseType#>,
            completion: <#T##(Result<Void, any Error>) -> (Void)#>
        )
    }
     */
}
