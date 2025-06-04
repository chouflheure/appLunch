import Foundation
import SwiftUI
import Firebase

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
            firstName: coordinator.user?.firstName ?? "",
            pseudo: coordinator.user?.pseudo ?? "",
            profilePictureUrl: coordinator.user?.profilePictureUrl ?? ""
        )
        friendsList = Set(coordinator.userFriends)

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
    
    func pushNewTeamToFirebase() {

        // TODO => Remove brouillon

        uploadImageToDataBase()
    }
    
    private func uploadImageToDataBase() {
        guard let imageProfile = imageProfile else { return }
        let uid = UUID()
        firebaseService.uploadImageStandard(
            picture: imageProfile,
            uidUser: uid.description,
            localisationImage: .team
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let urlString):
                    print("@@@ urlString = \(urlString)")
                    self.uploadTeamOnDataBase(urlStringImage: urlString)

                case .failure(let error):
                    Logger.log(error.localizedDescription, level: .error)
                }
            }
        }
    }
    
    private func uploadTeamOnDataBase(urlStringImage: String) {
        let uid = UUID()
        var friendsInTheTeam: [String] = []
        friendsInTheTeam = friendsAdd.map( {$0.uid})
        friendsInTheTeam.append(coordinator.user?.uid ?? "")

        let team = Team (
            uid: uid.description,
            title: nameTeam,
            pictureUrlString: urlStringImage,
            friends: friendsInTheTeam,
            admins: [coordinator.user?.uid ?? ""]
        )
        
        firebaseService.addData(data: team, to: .teams) { (result: Result<Void, Error>) in
            switch result{
            case .success():
                print("@@@ success")
                print("@@@ team = \(team.printObject)")
                self.addEventTeamOnFriendProfile(team: team)
            case .failure(let error):
                print("@@@ error = \(error)")
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
