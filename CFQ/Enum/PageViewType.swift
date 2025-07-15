
import SwiftUI

enum PageViewType {
    case searchFriends
    case attendingGuestsView
    case invited
    case profileView
    case friendList

    var titles: [String] {
        switch self {
            case .searchFriends:
                return ["Recherche", "Les demandes"]
            case .attendingGuestsView:
                return["✨ Tous", "👍", "🤔", "👎"]
            case .invited:
                return ["✨ Chaud", "👀 En attente"]
            case .profileView:
                return ["TURN", "CALENDRIER"]
            case .friendList:
                return ["En commun", "Tous"]
        }
    }

    func title(at index: Int) -> String {
        return titles[index]
    }
}

