import Foundation
import Firebase

class CFQFormViewModel: ObservableObject {

    @Published var researchText = String()
    @Published var friendsList = Set<UserContact>()
    @Published var friendsAddToCFQ = Set<UserContact>()
    @Published var teamAddToCFQ = Set<Team>()
    @Published var arrayTeam = Set<Team>()

    @Published var isLoading: Bool = false
    
    private var user: User
    private var firebaseService = FirebaseService()
    private var allFriends = Set<UserContact>()
    private var allTeams = Set<Team>()
    private var errorService = ErrorService()

    @Published var titleCFQ: String = ""

    var isEnableButton: Bool {
        get {
            (!friendsAddToCFQ.isEmpty || !teamAddToCFQ.isEmpty) && !titleCFQ.isEmpty
        }
        set {}
    }
    
    var filteredNames: Set<UserContact> {
        let searchWords = researchText.split(separator: " ").map { $0.lowercased() }
        return allFriends.filter { name in
            searchWords.allSatisfy { word in
                name.pseudo.lowercased().hasPrefix(word.lowercased())
            }
        }
    }

    var filteredTeams: Set<Team> {
        let searchWords = researchText.split(separator: " ").map { $0.lowercased() }
        return arrayTeam.filter { team in
            searchWords.allSatisfy { word in
                team.title.lowercased().hasPrefix(word.lowercased())
            }
        }
    }

    init(coordinator: Coordinator) {
        self.user = coordinator.user ?? User(uid: "")
        friendsList = Set(coordinator.user?.userFriendsContact ?? [])
        arrayTeam = Set(coordinator.user?.arrayTeamFromUser ?? [])
        allFriends = friendsList
        allTeams = arrayTeam
    }

    func removeFriendsFromList(user: UserContact) {
        friendsAddToCFQ.remove(user)
        friendsList.insert(user)
        allFriends.insert(user)
    }

    func removeTeamFromList(team: Team) {
        teamAddToCFQ.remove(team)
        arrayTeam.insert(team)
        allTeams.insert(team)
    }

    func addTeamToList(team: Team) {
        teamAddToCFQ.insert(team)
        arrayTeam.remove(team)
        allTeams.remove(team)
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
        arrayTeam = allTeams
        arrayTeam = filteredTeams
    }
}

extension CFQFormViewModel {

    func pushCFQ(completion: @escaping (Bool, String) -> Void) {
        
        isLoading = true
        let uuid = UUID()
        let messagerieUUID = UUID()
        var usersUUIDs = [String]()
        
        friendsAddToCFQ.forEach({ usersUUIDs.append($0.uid) })
        
        let cfq = CFQ(
            uid: uuid.description,
            title: "CFQ " + titleCFQ + (titleCFQ.last == "?" ? "" : " ?"),
            admin: user.uid,
            messagerieUUID: messagerieUUID.description,
            users: usersUUIDs,
            timestamp: Date()
        )
        
        firebaseService.addData(
            data: cfq,
            to: .cfqs,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    self.addEventCFQOnFriendProfile(cfq: cfq) { success, message in
                        completion(success, message)
                    }
                case .failure(let error):
                    print("@@@ error to add CFQ = \(error)")
                    completion(false, error.localizedDescription)
                }

                self.isLoading = false
            }
        )
    }

    func addEventCFQOnFriendProfile(cfq: CFQ, completion: @escaping (Bool, String) -> Void) {
        firebaseService.updateDataByID(
            data: [
                "postedCfqs": FieldValue.arrayUnion([cfq.uid]),
                "messagesChannelId": FieldValue.arrayUnion([cfq.messagerieUUID])
            ],
            to: .users,
            at: cfq.admin
        )

        firebaseService.addData(
            data: Conversation(
                uid: cfq.messagerieUUID,
                titleConv: cfq.title,
                pictureEventURL: user.profilePictureUrl,
                typeEvent: "cfq",
                eventUID: cfq.uid,
                lastMessageSender: "",
                lastMessageDate: Date(),
                lastMessage: "",
                messageReader: [user.uid]
            ),
            to: .conversations,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    completion(true, "")
                case .failure(let error):
                    completion(false, error.localizedDescription)
                }

                self.isLoading = false
            }
        )
        
        let uidNotification = UUID()
        
        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .cfqCreated,
                timestamp: Date(),
                uidUserNotif: user.uid,
                uidEvent: cfq.uid,
                titleEvent: cfq.title,
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: cfq.users,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ addDataNotif good ")
                case .failure(let error):
                    print("@@@ error addDataNotif = \(error)")
                }

                self.isLoading = false
            }
        )

        firebaseService.updateDataByIDs(
            data: [
                "invitedCfqs": FieldValue.arrayUnion([cfq.uid]),
                "messagesChannelId": FieldValue.arrayUnion([cfq.messagerieUUID])
            ],
            to: .users,
            at: cfq.users
        )
    }
    
    
    private func errorAuthFirebase(error: Error) -> String {
        let errorCode = (error as NSError).code
        let errorMessage: String

        switch errorCode {
        default:
            if errorCode == 17020 {
                print("Erreur réseau : \(error.localizedDescription)")
                errorMessage = "Problème de connexion internet"
            } else {
                errorMessage = "Une erreur inconnue est survenue."
            }
        }

        Logger.log(errorMessage, level: .error)

        return errorMessage
    }
}

