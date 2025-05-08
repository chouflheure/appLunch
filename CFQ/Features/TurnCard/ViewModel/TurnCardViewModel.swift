
import Foundation
import Combine
import SwiftUI

class Adresse {
    var placeTitle = String()
    var placeAdresse = String()
    var placeLatitude = Double()
    var placeLongitude = Double()
    
    init(placeTitle: String = "", placeAdresse: String = "", placeLatitude: Double = 0, placeLongitude: Double = 0) {
        self.placeTitle = placeTitle
        self.placeAdresse = placeAdresse
        self.placeLatitude = placeLatitude
        self.placeLatitude = placeLongitude
    }
}

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
    @Published var adresse = Adresse()

    @Published var showDetailTurnCard: Bool = false
    @Published var isPhotoPickerPresented: Bool = false

    var turn: Turn
    var adminUser: User
    var firebaseService = FirebaseService()
    
    var disableButtonSend: Bool {
        return false
        // return turn.titleEvent.isEmpty || turn.date == nil || moods.isEmpty || starthours == nil || imageSelected == nil || turn.description.isEmpty
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
    
    init(turn: Turn, coordinator: Coordinator) {
        
        self.turn = turn
        self.adminUser = coordinator.user ?? User(uid: "")
        
        verificationIdentificationUserUID(coordinator: coordinator)
        
        titleEvent = turn.titleEvent
        dateEvent = turn.date
        description = turn.description
        turn.mood.forEach { moods.insert(MoodType.convertIntToMoodType(MoodType(rawValue: $0)?.rawValue ?? 0)) }
        starthours = nil
        imageSelected = UIImage(resource: .background2)
        invited = turn.invited
        adresse.placeAdresse = turn.placeAdresse
        adresse.placeLatitude = turn.placeLatitude
        adresse.placeLongitude = turn.placeLongitude
        adresse.placeTitle = turn.placeTitle

        
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
    
}


extension TurnCardViewModel {
    func pushDataTurn() {

        // TODO => Remove brouillon

        uploadImageToDataBase()
    }
    
    private func uploadImageToDataBase() {
        guard let imageSelected = imageSelected else { return }
        firebaseService.uploadImage(picture: imageSelected, uidUser: "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let urlString):
                    self.uploadTurnOnDataBase(urlString: urlString)

                case .failure(let error):
                    Logger.log(error.localizedDescription, level: .error)
                }
            }
        }
    }
    
    private func uploadTurnOnDataBase(urlString: String) {
        print("@@@ here push")
        let uid = UUID()
        let messagerieUIID = UUID()

        var moodsInt: [Int] = []
        moods.forEach { moodsInt.append($0.convertMoodTypeToInt()) }
        
        let turn = Turn(
            uid: uid.description,
            titleEvent: titleEvent,
            date: dateEvent ?? Date(),
            pictureURLString: urlString,
            admin: adminUser.uid,
            description: description,
            invited: [""],
            participants:  [""],
            mood: moodsInt,
            messagerieUUID: messagerieUIID.description,
            placeTitle: "",
            placeAdresse: "",
            placeLatitude: 1.1,
            placeLongitude: 1.2
        )
        
        firebaseService.addData(data: turn, to: .turns) { (result: Result<Void, Error>) in
            switch result{
            case .success():
                print("@@@ success")
            case .failure(let error):
                print("@@@ error = \(error)")
            }
        }
    }
}
