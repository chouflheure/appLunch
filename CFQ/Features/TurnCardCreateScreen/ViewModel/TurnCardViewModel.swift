
import Foundation

class TurnCardViewModel: ObservableObject {
    
    var isEditing: Bool = true
    @Published var title = String()
    @Published var date = Date()
    @Published var moods = Set<MoodType>()
    @Published var adresse = String()
    @Published var description = String()
    @Published var starthours = String()
    @Published var endhours = String()
    
    
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
