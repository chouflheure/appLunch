
import CoreData
import SwiftUI

class TurnCoreDataViewModel: ObservableObject {
    private let container: NSPersistentContainer

    @Published var savedTurns: [TurnData] = []

    init() {
        container = NSPersistentContainer(name: "TurnContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("@@@ error to load CoreData \(error)")
            } else {
                self.fecthTurn()
            }
        }
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
    
    func addTurn(turn: TurnPreview, completion: @escaping (Bool, String) -> Void) {
        let context = container.viewContext
        
        // Créez l'entité en utilisant son nom exact dans le modèle
        guard NSEntityDescription.entity(forEntityName: "TurnData", in: context) != nil else {
            print("❌ introuvable dans le modèle")
            completion(false, "error lors de l'enregistrement")
            return
        }
        
        let newTurn = TurnData(context: context)
        var image = Data()
        
        if let imageData = turn.imageEvent?.pngData()  {
            image = imageData
        }

        newTurn.titleEvent = turn.titleEvent
        newTurn.descriptionEvent = turn.description
        newTurn.dateEvent = turn.dateStartEvent
        newTurn.imageEvent = image
        // newTurn.invited = turn.invited
        // newTurn.mood = turn.mood
        // newTurn.placeTitle = turn.placeTitle
            
        newTurn.placeLongitude = turn.placeLongitude
        newTurn.placeLatitude = turn.placeLatitude
        newTurn.placeAdresse = turn.placeAdresse

        do {
            try context.save()
            completion(true, "")
        } catch {
            completion(false, "error lors de l'enregistrement")
            print("Failed to save context: \(error)")
        }
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
        if index >= savedTurns.count {
            fecthTurn()
        } else {
            let context = container.viewContext
            context.delete(savedTurns[index])
            saveData()
        }
    }
}
