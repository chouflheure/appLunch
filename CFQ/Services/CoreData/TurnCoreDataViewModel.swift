
import CoreData
import SwiftUI

class TurnCoreDataViewModel: ObservableObject {
    private let nameCoreDataDB = "TurnContainer"
    private let container: NSPersistentContainer

    
    @Published var savedTurns: [TurnData] = []

    init() {
        container = NSPersistentContainer(name: "TurnContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("@@@ error to load CoreData \(error)")
            } else {
                print("@@@ success to load CoreData")
            }
        }
        fecthTurn()
    }
    
    func fecthTurn() {
        let context = container.viewContext
        let request = NSFetchRequest<TurnData>(entityName: "TurnData")
        
        do {
            savedTurns = try context.fetch(request)
            print("📊 \(savedTurns.count) turns récupérés")
        } catch let error {
            print("❌ Erreur lors de la récupération des turns: \(error)")
        }
    }
    
    
    
    func addTurn(turn: Turn) {
        let context = container.viewContext
        
        // Créez l'entité en utilisant son nom exact dans le modèle
        guard let entity = NSEntityDescription.entity(forEntityName: "TurnData", in: context) else {
            print("❌ introuvable dans le modèle")
            return
        }
        
        let newTurn = TurnData(context: context)
        newTurn.titleEvent = turn.titleEvent
        newTurn.descriptionEvent = turn.description
        // newTurn.invited = turn.invited
        // newTurn.mood = turn.mood
        // newTurn.placeTitle = turn.placeTitle
        newTurn.placeLongitude = turn.placeLongitude
        newTurn.placeLatitude = turn.placeLatitude
        newTurn.placeAdresse = turn.placeAdresse
        saveData()
    }
    
    func saveData() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
                print("✅ Données sauvegardées avec succès")
                fecthTurn()
            } catch {
                print("❌ Erreur lors de la sauvegarde: \(error)")
            }
        }
    }
    
    func deleteTurn(at index: Int) {
        let context = container.viewContext
        // context.delete(fruits[index])
        // saveData()
    }
}


/*
class TrunCoreData: NSManagedObject {
    @NSManaged var uid: String
    @NSManaged var titleEvent: String
    @NSManaged var date: Date?
    @NSManaged var descriptionEvent: String
    @NSManaged var invited: [String]
    @NSManaged var mood: [Int]
    @NSManaged var placeTitle: String
    @NSManaged var placeAdresse: String
    @NSManaged var placeLatitude: Double
    @NSManaged var placeLongitude: Double

    override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID().uuidString, forKey: "uid")
        setPrimitiveValue("", forKey: "titleEvent")
        setPrimitiveValue("", forKey: "description")
        setPrimitiveValue([""], forKey: "invited")
        setPrimitiveValue([0], forKey: "mood")
        setPrimitiveValue("", forKey: "placeTitle")
        setPrimitiveValue("", forKey: "placeAdresse")
        setPrimitiveValue(0, forKey: "placeLatitude")
        setPrimitiveValue(0, forKey: "placeLongitude")
    }

}
*/

struct TurnCoreDataView: View {
    @StateObject var vm = TurnCoreDataViewModel()

    var body: some View {
        Text("Hello, World!")
        Button(action: { vm.addTurn(turn: Turn(uid: "", titleEvent: "titleEvent", date: nil, pictureURLString: "", admin: "", description: "description", invited: [""], participants: [""], mood: [1], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 0, placeLongitude: 0)) }, label: {
            Text("click")
        })
    }
}
