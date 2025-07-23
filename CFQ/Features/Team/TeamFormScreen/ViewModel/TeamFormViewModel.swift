import Firebase
import SwiftUI

class TeamFormViewModel: ObservableObject {
    @Published var nameTeam = String()
    @Published var researchText = String()
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    @Published var team: Team?
    @Published var imageProfile: UIImage?
    @ObservedObject var coordinator: Coordinator
    @Published var isLoading: Bool = false
    
    var firebaseService = FirebaseService()

    let userContact: UserContact

    var isUserAdmin: Bool {
        get {
            adminList.contains(userContact)
        }
        set {}
    }

    @Published var adminList = Set<UserContact>()

    @Published var friendsAdd = Set<UserContact>()

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
        self.coordinator = coordinator

        userContact = UserContact(
            uid: coordinator.user?.uid ?? "",
            name: coordinator.user?.name ?? "",
            pseudo: coordinator.user?.pseudo ?? "",
            profilePictureUrl: coordinator.user?.profilePictureUrl ?? ""
        )
        friendsList = Set(coordinator.user?.userFriendsContact ?? [])

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

extension TeamFormViewModel {

    func pushNewTeamToFirebase(completion: @escaping (Bool, String) -> Void) {
        isLoading = true
        uploadImageToDataBase { success, message in
            if success {
                completion(true, "")
            } else {
                completion(false, message)
                self.isLoading = false
            }
        }
    }

    private func uploadImageToDataBase(
        completion: @escaping (Bool, String) -> Void
    ) {
        let uid = UUID()
        if let imageSelected = imageProfile {
            firebaseService.uploadImageStandard(
                picture: imageSelected,
                uidUser: uid.description,
                localisationImage: .team
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let urlString):
                        self.uploadTeamOnDataBase(urlStringImage: urlString) {
                            success,
                            message in
                            if success {
                                completion(success, "")
                            } else {
                                completion(false, message)
                            }
                        }

                    case .failure(let error):
                        Logger.log(error.localizedDescription, level: .error)
                        completion(false, error.localizedDescription)
                    }
                }
            }
        }
    }

    private func uploadTeamOnDataBase(
        urlStringImage: String,
        completion: @escaping (Bool, String) -> Void
    ) {
        let uid = UUID()
        var friendsInTheTeam: [String] = []
        friendsInTheTeam = friendsAdd.map({ $0.uid })
        friendsInTheTeam.append(coordinator.user?.uid ?? "")

        let team = Team(
            uid: uid.description,
            title: nameTeam,
            pictureUrlString: urlStringImage,
            friends: friendsInTheTeam,
            admins: [coordinator.user?.uid ?? ""],
            timestamp: Date()
        )

        firebaseService.addData(data: team, to: .teams) {
            (result: Result<Void, Error>) in
            switch result {
            case .success():
                print("@@@ success")
                print("@@@ team = \(team.printObject)")
                self.addEventTeamOnFriendProfile(team: team)
                self.coordinator.user?.teams?.append(team.uid)
                completion(true, "")
            case .failure(let error):
                print("@@@ error = \(error)")
                completion(false, error.localizedDescription)
            }
        }

    }

    func addEventTeamOnFriendProfile(team: Team) {

        firebaseService.updateDataByID(
            data: [
                "teams": FieldValue.arrayUnion([team.uid])
            ],
            to: .users,
            at: coordinator.user?.uid ?? ""
        )

        firebaseService.updateDataByIDs(
            data: [
                "teams": FieldValue.arrayUnion([team.uid])
            ],
            to: .users,
            at: team.friends
        )
    }
}
