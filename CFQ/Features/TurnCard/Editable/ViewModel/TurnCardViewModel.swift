
import Foundation
import Combine
import SwiftUI
import Firebase

class TurnCardViewModel: ObservableObject {

    @Published var titleEvent = String()
    @Published var dateEventStart: Date?
    @Published var dateEventEnd: Date?
    @Published var startHours: Date?
    @Published var endHours: Date?
    @Published var moods = Set<MoodType>()
    @Published var imageSelected: UIImage?
    @Published var description = String()
    @Published var invited = [String]()
    @Published var messagerieUUID = String()
    @Published var link = String()
    @Published var linkTitle = String()
    @Published var adminUID = String()
    @Published var placeTitle = String()
    @Published var placeAdresse = String()
    @Published var placeLatitude = Double()
    @Published var placeLongitude = Double()
    @Published var setFriendsOnTurn = Set<UserContact>()
    
    @Published var friendsList = Set<UserContact>()
    @Published var friendsAddToCFQ = Set<UserContact>()
    
    // @Published var allFriends = Set<UserContact>()
    @Published var isLoading: Bool = false
    @Published var showFriendsList: Bool = false
    @Published var showDetailTurnCard: Bool = false
    @Published var isPhotoPickerPresented: Bool = false

    @ObservedObject var coordinator: Coordinator

    var turn: Turn
    var user: User
    var firebaseService = FirebaseService()
    var allFriends: Set<UserContact> = []
    
    @Published var friendListToAdd = Set<UserContact>()
    
    var isEnableButton: Bool {
        get {
            !titleEvent.isEmpty && startHours != nil && !moods.isEmpty && dateEventStart != nil && !setFriendsOnTurn.isEmpty
        }
        set {}
    }

    var textFormattedLongFormatStartEvent: String {
        if let date = dateEventStart {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    var textFormattedHoursStartEvent: String {
        if let time = startHours {
            return time.formatted(date: .omitted, time: .shortened)
        }
        return ""
    }
    
    var textFormattedLongFormatEndEvent: String {
        if let date = dateEventEnd {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    var textFormattedHoursEndEvent: String {
        if let time = endHours {
            return time.formatted(date: .omitted, time: .shortened)
        }
        return ""
    }
    
    private func verificationIdentificationUserUID(coordinator: Coordinator) {
        if let user = coordinator.user {
            self.user = user
        } else {
            coordinator.showTurnCardView = false
        }
    }
    
    init(turn: Turn, coordinator: Coordinator) {

        self.turn = turn
        self.user = coordinator.user ?? User(uid: "")
        self.coordinator = coordinator
        self.allFriends = friendListToAdd

        verificationIdentificationUserUID(coordinator: coordinator)

        titleEvent = turn.titleEvent
        dateEventStart = turn.dateStartEvent
        description = turn.description
        // turn.mood.forEach { moods.insert(MoodType.convertIntToMoodType(MoodType(rawValue: $0)?.rawValue ?? 0)) }
        startHours = nil
        endHours = nil
        imageSelected = turn.imageEvent
        invited = turn.invited
        placeAdresse = turn.placeAdresse
        placeLatitude = turn.placeLatitude
        placeLongitude = turn.placeLongitude
        placeTitle = turn.placeTitle
        
        friendListToAdd = Set(coordinator.user?.userFriendsContact ?? [])
    }
    
    func textFormattedShortFormat() -> (jour: String, mois: String) {
        let formatter = DateFormatter()
        var jour = ""
        var mois = ""
        
        if let date = dateEventStart {
            formatter.dateFormat = "d"
            formatter.locale = Locale(identifier: "fr_FR")
            jour = formatter.string(from: date).capitalized
            
            formatter.dateFormat = "MMM"
            formatter.locale = Locale(identifier: "fr_FR")
            mois = formatter.string(from: date).uppercased()
        }

        return (jour, mois)
    }
    
    func showPhotoPicker() {
        Logger.log("Click on photo picker", level: .action)
            isPhotoPickerPresented = true
    }
    
    func removeFriendsFromList(user: UserContact) {
        setFriendsOnTurn.remove(user)
        friendListToAdd.insert(user)
        allFriends.insert(user)
    }
    
}

extension TurnCardViewModel {
    func pushDataTurn(completion: @escaping (Bool, String) -> Void) {

        // TODO => Remove brouillon
        isLoading = true
        uploadImageToDataBase {
            success, message in
            if success {
                completion(success, "")
            } else {
                self.isLoading = false
                completion(false, message)
            }
        }
    }
    
    private func uploadImageToDataBase(completion: @escaping (Bool, String) -> Void) {
        let uid = UUID()
        if let imageSelected = imageSelected {
            firebaseService.uploadImageStandard(picture: imageSelected, uidUser: uid.description, localisationImage: .turn) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let urlString):
                        self.uploadTurnOnDataBase(urlStringImage: urlString) { success, message in
                            if success {
                                completion(success, "")
                            } else {
                                completion(false, message)
                            }
                        }

                    case .failure(let error):
                        Logger.log(error.localizedDescription, level: .error)
                        self.isLoading = false
                        completion(false, error.localizedDescription)
                    }
                }
            }
        } else {
            print("@@@ else ")
            uploadTurnOnDataBase(urlStringImage: "") { success, message in
                if success {
                    print("@@@ if 1")
                    completion(success, "")
                } else {
                    print("@@@ else 2")
                    completion(false, message)
                }
            }
        }
    }
    
    private func uploadTurnOnDataBase(urlStringImage: String, completion: @escaping (Bool, String) -> Void) {
        let uid = UUID()
        let messagerieUIID = UUID()

        var moodsInt: [Int] = []
        var friends: [String] = []
        moods.forEach { moodsInt.append($0.convertMoodTypeToInt()) }
        setFriendsOnTurn.forEach { friends.append($0.uid) }

        let turn = Turn(
            uid: uid.description,
            titleEvent: titleEvent,
            dateStartEvent: dateEventStart ?? Date(),
            dateEndEvent: dateEventEnd,
            pictureURLString: urlStringImage,
            admin: user.uid,
            description: description,
            invited: friends,
            participants: [],
            denied: [],
            mayBeParticipate: [],
            mood: moodsInt,
            messagerieUUID: messagerieUIID.description,
            placeTitle: placeTitle,
            placeAdresse: placeAdresse,
            placeLatitude: placeLatitude,
            placeLongitude: placeLongitude,
            timestamp: Date()
        )

        if !linkTitle.isEmpty && !link.isEmpty {
            turn.linkTitle = linkTitle
            turn.link = link
        }

        firebaseService.addData(data: turn, to: .turns) { (result: Result<Void, Error>) in
            switch result{
            case .success():
                self.addEventTurnOnFriendProfile(turn: turn) { success, message in
                    if success {
                        print("@@@ if 3")
                        completion(success, "")
                    } else {
                        print("@@@ else 3")
                        completion(false, message)
                    }
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func addEventTurnOnFriendProfile(turn: Turn, completion: @escaping (Bool, String) -> Void) {
        firebaseService.updateDataByID (
            data: [
                "messagesChannelId": FieldValue.arrayUnion([turn.messagerieUUID]),
                "postedTurns": FieldValue.arrayUnion([turn.uid])
            ],
            to: .users,
            at: turn.admin
        )

        firebaseService.addData(
            data: Conversation(
                uid: turn.messagerieUUID,
                titleConv: turn.titleEvent,
                pictureEventURL: turn.pictureURLString,
                typeEvent: "turn",
                eventUID: turn.uid,
                lastMessageSender: "",
                lastMessageDate: Date(),
                lastMessage: "",
                messageReader: [user.uid]
            ),
            to: .conversations,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes conv ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )
        
        let uidNotification = UUID()
        
        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .turnCreated,
                timestamp: Date(),
                uidUserNotif: user.uid,
                uidEvent: turn.uid,
                titleEvent: turn.titleEvent,
                userInitNotifPseudo: user.pseudo
            ),
            userNotifications: turn.invited,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes notif ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }
            }
        )
        
        firebaseService.updateDataByIDs(
            data: [
                "invitedTurns": FieldValue.arrayUnion([turn.uid]),
                "messagesChannelId": FieldValue.arrayUnion([turn.messagerieUUID])
            ],
            to: .users,
            at: turn.invited
        )
        
        completion(true, "")
        
        self.isLoading = false
    }
}
