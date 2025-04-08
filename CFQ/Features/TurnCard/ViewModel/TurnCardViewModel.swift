
import Foundation
import Combine

class TurnCardViewModel: ObservableObject {
    
    @Published var isEditing: Bool = true
    @Published var title = String()
    @Published var date = Date()
    @Published var moods = Set<MoodType>()
    @Published var adresse = String()
    @Published var description = "Diner entre \ngirls <3 Ramenez \njuste à boire! Diner \nentre girls <3 \nRamenez juste \nà boire! Diner \nentre girls <3 \nRamenez juste à boire\n! Ramenez juste \nà boire"
    @Published var starthours = String()
    @Published var endhours = String()
    @Published var showDetailTurnCard: Bool = false

    func textFormattedLongFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE  d  MMMM"
        formatter.locale = Locale(identifier: "fr_FR")
        return formatter.string(from: date).capitalized
    }

    func textFormattedShortFormat() -> (jour: String, mois: String) {
        let formatter = DateFormatter()

        formatter.dateFormat = "d"
        formatter.locale = Locale(identifier: "fr_FR")
        let jour = formatter.string(from: date).capitalized

        formatter.dateFormat = "MMM"
        formatter.locale = Locale(identifier: "fr_FR")
        let mois = formatter.string(from: date).uppercased()

        return (jour, mois)
    }
    
    
}
