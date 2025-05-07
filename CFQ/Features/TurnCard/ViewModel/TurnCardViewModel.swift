
import Foundation
import Combine
import SwiftUI

class TurnCardViewModel: ObservableObject {

    @Published var titleEvent = String()
    @Published var dateEvent: Date?
    @Published var moods = Set<MoodType>()
    @Published var adresse = String()
    @Published var starthours: Date?
    @Published var imageSelected: Image?
    @Published var showDetailTurnCard: Bool = false
    @Published var isPhotoPickerPresented: Bool = false
    @Published var description = String()

    var turn: Turn
    var firebaseService = FirebaseService()
    
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
    
    init(turn: Turn) {
        self.turn = turn
        titleEvent = turn.titleEvent
        dateEvent = turn.date
        adresse = turn.placeTitle
        description = turn.description
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

        print("@@@ here push")
        let uid = UUID()
        let turn = Turn(
            uid: uid.description,
            titleEvent: titleEvent,
            date: dateEvent ?? Date(),
            pictureURLString: "", // push Image on Data base
            admin: "", // userID
            description: description,
            invited: [""],
            participants:  [""],
            mood: [0],
            messagerieUUID: "",
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
