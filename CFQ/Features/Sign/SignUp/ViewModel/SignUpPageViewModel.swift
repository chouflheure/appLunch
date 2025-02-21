import Foundation
import SwiftUI
import FirebaseAuth

class SignUpPageViewModel: ObservableObject {
    @Published var index = 0
    @Published var name = String()
    @Published var firstName = String()
    @Published var pseudo = String()
    @Published var birthday = Date()
    @Published var localisation = String()
    @Published var picture = UIImage()
    @Published var friend = String()
    @Published var friends: [String] = []
    private var user: User?
    var uidUser: String

    init(uidUser: String) {
        self.uidUser = uidUser
    }

    func addFriend() {
        friends.append(friend ?? "")
        print("Amis actuels : \(friends)")
    }

    func uploadPicture() {
        self.picture = UIImage(systemName: "person.circle") ?? UIImage(resource: .disco)
    }

    func goNext() {
        if index + 1 < 4 {
            withAnimation {
                index = min(index + 1, 3)
            }
        }
    }

    func goBack() {
        if index > 0 {
            withAnimation {
                index = max(index - 1, 0)
            }
        }
    }
    
    func setupUser() {
        user = User(
            uid: uidUser,
            name: name,
            firstName: firstName,
            username: pseudo,
            profilePictureUrl: "",
            location: [],
            isActive: true,
            favorite: [],
            friends: [],
            invitedCfqs: [],
            invitedTurns: [],
            notificationsChannelId: "",
            postedCfqs: [],
            postedTurns: [],
            teams: [],
            tokenFCM: "",
            unreadNotificationsCount: 0
        )
    }
}


