
import Foundation
import Combine
import SwiftUI

class TurnCardViewModel: ObservableObject {
    
    @Published var isEditing: Bool = true
    @Published var title = String()
    @Published var date: Date?
    @Published var moods = Set<MoodType>()
    @Published var adresse = String()
    @Published var starthours = String()
    @Published var endhours = String()
    @Published var showDetailTurnCard: Bool = false
    @Published var imageSelected: Image?
    @Published var isPhotoPickerPresented: Bool = false

    @Published var description = "Diner entre \ngirls <3 Ramenez \njuste à boire! Diner \nentre girls <3 \nRamenez juste \nà boire! Diner \nentre girls <3 \nRamenez juste à boire\n! Ramenez juste \nà boire"

    var dateEvent: String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    var textFormattedLongFormat: String {
        if let date = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE  d  MMMM"
            formatter.locale = Locale(identifier: "fr_FR")
            return formatter.string(from: date).capitalized
        }
        return ""
    }

    func textFormattedShortFormat() -> (jour: String, mois: String) {
        let formatter = DateFormatter()
        var jour = ""
        var mois = ""
        
        if let date = date {
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
        
    }
}
