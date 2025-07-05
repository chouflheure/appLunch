
import Foundation

enum LocalisationType: String, CaseIterable {
    case Paris = "Paris"
    case Aix = "Aix-en-Provence"
    case Marseille = "Marseille"
    case Angers = "Angers"
    case Annecy = "Annecy"
    case Biarritz = "Biarritz"
    case Bordeaux = "Bordeaux"
    case Lille = "Lille"
    case Lyon = "Lyon"
    case Strasbourg = "Strasbourg"
    case Toulouse = "Toulouse"
    case Tours = "Tours"
}

enum PlaceType: String, CaseIterable {
    case ChezMoi = "Chez moi"
    case ChezMesParents = "Chez mes parents"
    case EnBoite = "En boite"
    case DansLeParc = "Dans le parc"
    case AuBar = "Au bar"
    case DansLaRue = "Dans la rue"
}
