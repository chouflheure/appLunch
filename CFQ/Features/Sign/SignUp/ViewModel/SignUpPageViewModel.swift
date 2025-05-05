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
    @Published var isDoneUpdateUser = false
    @Published var friends: [String] = []
    @Published var contacts: [UserContact] = []
    @Published var isFetchingContacts: Bool = false

    // isLoadingPictureUpload
    @Published var isLoadingPictureUpload: Bool = false
    @Published var isLoadingPictureUploadDone: Bool = false
    @Published var isLoadingPictureUploadError: Bool = false
    
    // isLoadingCreateUser
    @Published var isLoadingCreateUser: Bool = false
    @Published var isLoadingCreateUserDone: Bool = false
    @Published var isLoadingCreateUserNone: Bool = false
    
    
    var coordinator: Coordinator?
    private var urlProfilePicture = String()
    private let firebaseService = FirebaseService()
    

    @Published var user = User(
        uid: "",
        name: "",
        firstName: "",
        pseudo: "",
        profilePictureUrl: "",
        location: "",
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
        isFetchingContacts = true
        DispatchQueue.global(qos: .userInitiated).async {
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

                    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)

                    do {
                        try store.enumerateContacts(with: fetchRequest) {
                            (contact, stop) in
                            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                                let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "+", with: "")
                                phoneNumberIds.append(formattedPhoneNumber)
                                print("@@@ formattedPhoneNumber: \(formattedPhoneNumber)")
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
                            }
                        }
                    } catch {
                        print("@@@ Error fetching contacts: \(error)")
                    }
                } else {
                    print("Access denied to contacts.")
                }
            }
        }
        isFetchingContacts = false
    }

    // TODO: - Update error messages
    private func uploadImageToDataBase() {
        firebaseService.uploadImage(picture: picture, uidUser: uidUser) { result in
            switch result {
            case .success(let urlString):
                DispatchQueue.main.async {
                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                        self.user.tokenFCM = fcmToken
                    }
                    self.urlProfilePicture = urlString
                    self.isLoadingPictureUpload = false
                    self.isLoadingPictureUploadDone = true
                    self.uploadDataUser()
                }
            case .failure(let error):
                print("@@@ failure ")
                print("Erreur lors du téléversement de l'image : \(error.localizedDescription)")
                
                // TODO: Gérer l'erreur de manière appropriée
                self.isLoadingPictureUpload = false
                self.isLoadingPictureUploadError = true
            }
        }
        self.isLoadingPictureUploadDone = false
        self.isLoadingPictureUploadError = false
    }
    

    private func uploadDataUser() {
        user.uid = uidUser
        user.tokenFCM = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        user.profilePictureUrl = urlProfilePicture
        
        isLoadingCreateUser = true
        
        // TODO: - gérer erreur et isLoadingCreateUser

        firebaseService.addData(data: user, to: .users) { (result: Result<Void, Error>) in
            switch result {
            case .success():
                self.isLoadingCreateUser = false
                self.coordinator?.gotoCustomTabView(user: self.user)
            case .failure(let error):
                self.isLoadingCreateUser = false
                print("@@@ error = \(error)")
            }
        }
    }

    private func fetchDataContactUser(completion: @escaping ([UserContact]) -> Void) {
        firebaseService.getAllData(from: .usersPreviews) { (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                completion(users)
            case .failure(let error):
                print("- Erreur :", error.localizedDescription)
            }
        }
    }

    func addUserDataOnDataBase(coordinator: Coordinator, completion: @escaping (Bool, String) -> Void) {
        self.coordinator = coordinator
        isLoadingPictureUpload = true
        uploadImageToDataBase()
    }

}
