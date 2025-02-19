import Foundation
import SwiftUI
import FirebaseAuth

class SignUpPageViewModel: ObservableObject {
    @Published var index = 0
    
    @Published var name: String = ""
    @Published var firstName: String = ""
    @Published var pseudo: String = ""
    
    @Published var birthday: Date = Date()
    
    @Published var picture: UIImage?
    @Published var friend : String = ""
    @Published var friends: [String] = []

    func addFriend() {
        friends.append(friend)
        print("Amis actuels : \(friends)")
    }

    func uploadPicture() {
        self.picture = UIImage(systemName: "person.circle")
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
}


