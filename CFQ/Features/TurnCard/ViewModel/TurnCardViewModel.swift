
import Foundation
import Combine
import SwiftUI
import Firebase

class TurnCardViewModel: ObservableObject {

    @Published var titleEvent = String()
    @Published var dateEvent: Date?
    @Published var moods = Set<MoodType>()
    @Published var starthours: Date?
    @Published var imageSelected: UIImage?
    @Published var description = String()
    @Published var invited = [String]()
    @Published var messagerieUUID = String()
    @Published var adminUID = String()
    @Published var placeTitle = String()
    @Published var placeAdresse = String()
    @Published var placeLatitude = Double()
    @Published var placeLongitude = Double()
    @Published var setFriendsOnTurn = Set<UserContact>()
    
    // @Published var allFriends = Set<UserContact>()
    
    @Published var showFriendsList: Bool = false
    @Published var showDetailTurnCard: Bool = false
    @Published var isPhotoPickerPresented: Bool = false

    @ObservedObject var coordinator: Coordinator

    var turn: TurnPreview
    var adminUser: User
    var firebaseService = FirebaseService()
    var allFriends: Set<UserContact> = []
    
    @Published var friendListToAdd = Set<UserContact>()
    
    var disableButtonSend: Bool {
        return turn.titleEvent.isEmpty || turn.date == nil || moods.isEmpty || starthours == nil || imageSelected == nil || turn.description.isEmpty
    }

    var textFormattedLongFormat: String {
        if let date = dateEvent {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    var textFormattedHours: String {
        if let time = starthours {
            return time.formatted(date: .omitted, time: .shortened)
        }
        return ""
    }
    
    private func verificationIdentificationUserUID(coordinator: Coordinator) {
        if let adminUser = coordinator.user {
            self.adminUser = adminUser
        } else {
            coordinator.showTurnCardView = false
        }
    }
    
    init(turn: TurnPreview, coordinator: Coordinator) {

        self.turn = turn
        self.adminUser = coordinator.user ?? User(uid: "")
        self.coordinator = coordinator
        self.allFriends = friendListToAdd

        verificationIdentificationUserUID(coordinator: coordinator)

        titleEvent = turn.titleEvent
        dateEvent = turn.date
        description = turn.description
        // turn.mood.forEach { moods.insert(MoodType.convertIntToMoodType(MoodType(rawValue: $0)?.rawValue ?? 0)) }
        starthours = nil
        imageSelected = turn.imageEvent
        invited = turn.invited
        placeAdresse = turn.placeAdresse
        placeLatitude = turn.placeLatitude
        placeLongitude = turn.placeLongitude
        placeTitle = turn.placeTitle
        
        friendListToAdd = Set(coordinator.userFriends)
    }
    
    func textFormattedShortFormat() -> (jour: String, mois: String) {
        let formatter = DateFormatter()
        var jour = ""
        var mois = ""
        
        if let date = dateEvent {
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
    func pushDataTurn() {

        // TODO => Remove brouillon

        uploadImageToDataBase()
    }
    
    private func uploadImageToDataBase() {
        let uid = UUID()
        guard let imageSelected = imageSelected else { return }
        firebaseService.uploadImage(picture: imageSelected, uidUser: uid.description, localisationImage: .turn) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let urlString):
                    self.uploadTurnOnDataBase(urlStringImage: urlString)

                case .failure(let error):
                    Logger.log(error.localizedDescription, level: .error)
                }
            }
        }
    }
    
    private func uploadTurnOnDataBase(urlStringImage: String) {
        let uid = UUID()
        let messagerieUIID = UUID()

        var moodsInt: [Int] = []
        var friends: [String] = []
        moods.forEach { moodsInt.append($0.convertMoodTypeToInt()) }
        setFriendsOnTurn.forEach { friends.append($0.uid) }

        let turn = Turn(
            uid: uid.description,
            titleEvent: titleEvent,
            date: dateEvent ?? Date(),
            pictureURLString: urlStringImage,
            admin: adminUser.uid,
            description: description,
            invited: friends,
            participants: [],
            denied: [],
            mood: moodsInt,
            messagerieUUID: messagerieUIID.description,
            placeTitle: "",
            placeAdresse: "",
            placeLatitude: 1.1,
            placeLongitude: 1.2,
            timestamp: Date()
        )
        
        firebaseService.addData(data: turn, to: .turns) { (result: Result<Void, Error>) in
            switch result{
            case .success():
                print("@@@ success")
                self.addEventTurnOnFriendProfile(turn: turn)
            case .failure(let error):
                print("@@@ error = \(error)")
            }
        }
         
    }
    
    func addEventTurnOnFriendProfile(turn: Turn) {
        firebaseService.updateDataByID(
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
                pictureEventURL: adminUser.profilePictureUrl,
                typeEvent: "turn",
                eventUID: turn.uid,
                lastMessageSender: "",
                lastMessageDate: Date(),
                lastMessage: "",
                messageReader: [adminUser.uid]
            ),
            to: .conversations,
            completion: { (result: Result<Void, Error>) in
                switch result {
                case .success():
                    print("@@@ result yes conv ")
                case .failure(let error):
                    print("@@@ error = \(error)")
                }

                // self.isLoading = false
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
    }
}
