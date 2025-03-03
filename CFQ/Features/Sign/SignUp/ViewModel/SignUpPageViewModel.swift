import Contacts
import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

class SignUpPageViewModel: ObservableObject {
    private var uidUser: String

    @Published var index = 0
    @Published var name = String()
    @Published var firstName = String()
    @Published var pseudo = String()
    @Published var birthday = Date()
    @Published var locations = Set<String>()
    @Published var picture = UIImage()

    @Published var friend = String()
    @Published var friends: [String] = []
    @Published var contacts: [UserContact] = []
    @State private var uploadStatus: String = ""
    
    private var urlProfilePicture = String()
    private let firebase = FirebaseService()

    private var user: User {
        User(
            uid: uidUser,
            name: name,
            firstName: firstName,
            pseudo: pseudo,
            profilePictureUrl: urlProfilePicture,
            location: locations,
            isActive: true,
            favorite: [""],
            friends: [""],
            invitedCfqs: [""],
            invitedTurns: [""],
            notificationsChannelId: "",
            postedCfqs: [""],
            postedTurns: [""],
            teams: [""],
            tokenFCM: "",
            unreadNotificationsCount: 0
        )
    }

    init(uidUser: String) {
        self.uidUser = uidUser
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

    func fetchContacts() {
        let store = CNContactStore()
        var phoneNumberIds: [String] = []

        // Demander l'autorisation d'accéder aux contacts
        store.requestAccess(for: .contacts) {
            [weak self] (isAuthorized, error) in
            if isAuthorized {
                // Accéder aux contacts si l'autorisation est donnée
                let keysToFetch: [CNKeyDescriptor] = [
                    CNContactGivenNameKey as CNKeyDescriptor,
                    CNContactFamilyNameKey as CNKeyDescriptor,
                    CNContactPhoneNumbersKey as CNKeyDescriptor,
                ]

                let fetchRequest = CNContactFetchRequest(
                    keysToFetch: keysToFetch)

                do {
                    try store.enumerateContacts(with: fetchRequest) {
                        (contact, stop) in
                        if let phoneNumber = contact.phoneNumbers.first?.value
                            .stringValue
                        {
                            print("@@@ phoneNumber = \(phoneNumber)")
                            let formattedPhoneNumber =
                                phoneNumber.replacingOccurrences(
                                    of: " ", with: ""
                                ).replacingOccurrences(of: "+", with: "")
                            phoneNumberIds.append(formattedPhoneNumber)
                        }
                    }

                    self?.fetchDataContactUser { users in
                        var arrayUsersContact: [UserContact] = []
                        DispatchQueue.main.async {
                            for user in users {
                                if phoneNumberIds.contains(user.uid) {
                                    arrayUsersContact.append(user)
                                }
                            }
                            self?.contacts = Array(Set(arrayUsersContact))
                            print("contacts = \(self?.contacts)")
                        }
                    }
                } catch {
                    print("Error fetching contacts: \(error)")
                }
            } else {
                print("Access denied to contacts.")
            }
        }
    }

    // TODO: - Update error messages
    private func uploadImage() {
        firebase.uploadImage(picture: picture, uidUser: user.uid) { result in
            switch result {
            case .success(let urlString):
                self.user.profilePictureUrl = urlString
                self.uploadDataUser()
            case .failure(let error): break
                // TODO: Update error
            }
        }
    }
    
    private func uploadDataUser() {
        firebase.addData(data: user, to: .users) { (result: Result<Void, Error>) in
            switch result {
            case .success():
                // completion(true, "")
                return
            case .failure(let error):
                // TODO: Implement error message
                // completion(false, error.localizedDescription)
                return
            }
        }
    }

    private func fetchDataContactUser(
        completion: @escaping ([UserContact]) -> Void
    ) {
        firebase.getAllData(from: .usersPreviews) {
            (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                completion(users)
            case .failure(let error):
                print("- Erreur :", error.localizedDescription)
            }
        }
    }
    
    private func updateProfilePictureURL() {
        firebase.updateDataByID(data: ["profilePictureUrl": urlProfilePicture], to: .users, at: uidUser)
    }

    func addUserDataOnDataBase(completion: @escaping (Bool, String) -> Void) {
        uploadImage()
    }

}
