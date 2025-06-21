import Contacts
import Firebase
import FirebaseAuth
import Foundation
import SwiftUI

class SignUpPageViewModel: ObservableObject {
    private var uidUser: String
    private var phoneNumber: String

    @Published var index = 0
    @Published var name = String()
    @Published var firstName = String()
    @Published var pseudo = String()
    @Published var birthday = Date()
    @Published var locations = Set<String>()
    @Published var picture = UIImage()
    @Published var isDoneUpdateUser = false
    @Published var friends: [String] = []
    @Published var contacts: [UserContactPhoneNumber] = []
    @Published var isFetchingContacts: Bool = false
    @Published var sentFriendRequests = Set<String>()
    

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
        birthDate: Date(),
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

    init(uidUser: String, phoneNumber: String) {
        self.uidUser = uidUser
        self.phoneNumber = phoneNumber
    }

    func goNext() {
        if index + 1 < 5 {
            withAnimation {
                index = min(index + 1, 4)
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

    func formattedDate() -> (isPlaceholder: Bool, titleButton: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        var isPlaceholder: Bool = false

        let calendar = Calendar.current
        if calendar.isDate(birthday, inSameDayAs: Date()) {
            isPlaceholder = true
            return (isPlaceholder, "01/01/2001")
        } else {
            isPlaceholder = false
            return (isPlaceholder, formatter.string(from: birthday))
        }
    }
    
    func fetchContacts() {
        isFetchingContacts = true
        DispatchQueue.global(qos: .userInitiated).async {
            let store = CNContactStore()

            store.requestAccess(for: .contacts) {
                [weak self] (isAuthorized, error) in
                if isAuthorized {
                    let keysToFetch: [CNKeyDescriptor] = [
                        CNContactGivenNameKey as CNKeyDescriptor,
                        CNContactFamilyNameKey as CNKeyDescriptor,
                        CNContactPhoneNumbersKey as CNKeyDescriptor,
                    ]

                    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)

                    do {
                        // Récupérer tous les contacts téléphoniques
                        var phoneContacts: [(name: String, phoneNumber: String)] = []
                        
                        try store.enumerateContacts(with: fetchRequest) { (contact, stop) in
                            if let phoneNumber = contact.phoneNumbers.first?.value.stringValue {
                                let formattedPhoneNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
                                let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
                                phoneContacts.append((name: fullName, phoneNumber: formattedPhoneNumber))
                            }
                        }
                        
                        print("📱 Contacts téléphoniques récupérés: \(phoneContacts.count)")
                        
                        // Récupérer les utilisateurs de la base
                        self?.fetchDataContactUser(phoneNumbers: phoneContacts.compactMap({$0.phoneNumber})) { users in
                            print("👥 Utilisateurs en base: \(users.count)")
                            
                            DispatchQueue.main.async {
                                let finalContacts = self?.mergeContactsWithUsers(phoneContacts: phoneContacts, users: users) ?? []
                                
                                self?.contacts = finalContacts
                                print("✅ Contacts finaux fusionnés: \(finalContacts.count)")

                                finalContacts.forEach { contact in
                                    print("📋 \(contact.printObject)")
                                }
                            }
                        }
                    } catch {
                        print("❌ Erreur lors de la récupération des contacts: \(error)")
                    }
                } else {
                    print("Access denied to contacts.")
                }
            }
        }
        isFetchingContacts = false
    }

    private func mergeContactsWithUsers(
        phoneContacts: [(name: String, phoneNumber: String)],
        users: [UserContactPhoneNumber]
    ) -> [UserContactPhoneNumber] {

        let usersByPhone: [String: UserContactPhoneNumber] = Dictionary(
            uniqueKeysWithValues: users.compactMap { user in
                let formattedPhone = user.phoneNumber
                    .replacingOccurrences(of: " ", with: "")
                return (formattedPhone, user)
            }
        )
        
        var mergedContacts: [UserContactPhoneNumber] = []
        
        
        for phoneContact in phoneContacts {
            if let matchedUser = usersByPhone[phoneContact.phoneNumber] {
                let mergedContact = UserContactPhoneNumber(
                    uid: matchedUser.uid,
                    name: phoneContact.name,
                    pseudo: matchedUser.pseudo,
                    phoneNumber: phoneContact.phoneNumber,
                    profilePictureUrl: matchedUser.profilePictureUrl
                )
                mergedContacts.append(mergedContact)
            }
        }

        return Array(Set(mergedContacts))
    }

    // TODO: - Update error messages
    private func uploadImageToDataBase() {
        firebaseService.uploadThumbnail(picture: picture, uidUser: uidUser, localisationImage: .profile) { result in
            DispatchQueue.main.async {
                self.isLoadingPictureUpload = false
                switch result {
                case .success(let urlString):
                    if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                        self.user.tokenFCM = fcmToken
                    }
                    self.urlProfilePicture = urlString
                    self.isLoadingPictureUploadError = false
                    self.isLoadingPictureUploadDone = true
                    self.uploadDataUser()

                case .failure(let error):
                    print("@@@ failure ")
                    print("@@@ Erreur lors du téléversement de l'image : \(error.localizedDescription)")
                    self.isLoadingPictureUploadDone = false
                    self.isLoadingPictureUploadError = true
                    // TODO: Gérer l'erreur de manière appropriée
                }
            }
        }
    }

    private func uploadDataUser() {
        user.uid = uidUser
        user.tokenFCM = UserDefaults.standard.string(forKey: "fcmToken") ?? ""
        user.profilePictureUrl = urlProfilePicture
        user.sentFriendRequests = Array(sentFriendRequests)
        user.phoneNumber = phoneNumber
        user.notificationsChannelId = uidUser
        
        // TODO: - gérer erreur et isLoadingCreateUser

        firebaseService.addData(data: user, to: .users) { (result: Result<Void, Error>) in
            switch result {
            case .success():
                self.addFriendsToList(userFriendIds: Array(self.sentFriendRequests))
            case .failure(let error):
                print("@@@ error update user = \(error)")
            }
        }
    }

    private func fetchDataContactUser(phoneNumbers: [String], completion: @escaping ([UserContactPhoneNumber]) -> Void) {
        firebaseService.getUsersByPhoneNumbersBatch(
            from: .users,
            phoneNumbers: phoneNumbers
        ) { (result: Result<[UserContactPhoneNumber], Error>) in
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

    func askToBeFriend(isAskToBeFriend: Bool, userFriendId: String) {
        if isAskToBeFriend {
            sentFriendRequests.insert(userFriendId)
        } else {
            sentFriendRequests.remove(userFriendId)
        }
    }
    
    private func addFriendsToList(userFriendIds: [String]) {

        firebaseService.updateDataByIDs(
            data: ["requestsFriends": FieldValue.arrayUnion([user.uid])],
            to: .users,
            at: userFriendIds
        )

        let uidNotification = UUID()

        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .friendRequest,
                timestamp: Date(),
                uidUserNotif: self.user.uid,
                uidEvent: "",
                titleEvent: "Become friends",
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: userFriendIds,
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
}
