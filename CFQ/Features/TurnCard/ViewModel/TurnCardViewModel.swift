
import Foundation
import Combine
import SwiftUI

class TurnCardViewModel: ObservableObject {

    @Published var titleEvent = String()
    @Published var dateEvent: Date?
    @Published var moods = Set<MoodType>()
    @Published var adresse = String()
    @Published var starthours: Date?
    @Published var showDetailTurnCard: Bool = false
    @Published var imageSelected: Image?
    @Published var isPhotoPickerPresented: Bool = false
    
    @Published var description = "Diner entre \ngirls <3 Ramenez \njuste à boire! Diner \nentre girls <3 \nRamenez juste \nà boire! Diner \nentre girls <3 \nRamenez juste à boire\n! Ramenez juste \nà boire"

    var firebaseService = FirebaseService()
    
    var disableButtonSend: Bool {
        return titleEvent.isEmpty || dateEvent == nil || moods.isEmpty || starthours == nil || imageSelected == nil || description.isEmpty
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

        print("@@@ here push")

        let uid = UUID()
        let turn = Turn(
            uid: uid.description,
            title: titleEvent,
            date: dateEvent ?? Date(),
            pictureUrlString: "",
            friends: [""]
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
