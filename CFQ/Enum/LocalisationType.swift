
import Foundation

enum LocalisationType: CaseIterable {
    case Paris
    case Aix
    case Marseille
    case Angers
    case Annecy
    case Biarritz
    case Bordeaux
    case Lille
    case Lyon
    case Strasbourg
    case Toulouse
    case Tours
    
    var title: String {
        switch self {
        case .Paris:
            return "Paris"
        case .Aix:
            return "Aix-en-Provence"
        case .Angers:
            return "Angers"
        case .Annecy:
            return "Annecy"
        case .Marseille:
            return "Marseille"
        case .Biarritz:
            return "Biarritz"
        case .Bordeaux:
            return "Bordeaux"
        case .Lille:
            return "Lille"
        case .Lyon:
            return "Lyon"
        case .Strasbourg:
            return "Strasbourg"
        case .Toulouse:
            return "Toulouse"
        case .Tours:
            return "Tours"
        }
    }
}
