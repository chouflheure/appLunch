
import Foundation
import SwiftUI

class MessagerieScreenViewModel: ObservableObject {
    @Published var showSettingMessagerie: Bool = false
    @Published var showDetailGuest: Bool = false
    @Published var showConversationOptionView: Bool = false

    let firebaseService = FirebaseService()
    // @ObservedObject var coordinator: Coordinator

    init() {//coordinator: Coordinator) {
        // self.coordinator = coordinator
        fectchmessagesToDB()
    }

    
    @Published var textMessage: String = ""
    @Published var messages: [String] = [
        "Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ",
        "Vasy Go",
        "c'est mort c'est null comme coin",
        "Ouais bien d'accord, pas ouf .. 😅",
        "On parle de quoi je n'ai pas lu les messages précédents",
        "Comme d'hab ahaha "
    ]
 
    /*
     Text("Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 Chaud d’un verre dans le 18 😂 Chaud d’un verre dans le ")
     */
}


extension MessagerieScreenViewModel {
    
    func fectchmessagesToDB() {
        firebaseService.getDataByIDs(
            from: .conversations,
            with: ["DO3ooq4uveQVzN3cCujf"],
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
        ) { [weak self] (result: Result<[Conversation], Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let fetchedConv):
                // Stockez les turns récupérés
                DispatchQueue.main.async {
                    fetchedConv.forEach({
                        print("@@@ \(String(describing: $0.printObject))")
                    })

                    /*
                    for (index, conv) in fetchedConv.enumerated() {
                        switch conv.typeEvent {
                        case "cfq":
                            // self?.fetchEventCFQ(at: index, cfqUID: conv.eventUID)
                        case "turn":
                            print("@@@ here")
                            self?.fetchEventTurn(at: index, turnUID: conv.eventUID)
                        default:
                            break
                        }
                    }
                    // self.turns = fetchedTurns
                     */
                }
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
                print("@@@ error = \(error)")
            }
        }
    }
    
    
    
    func fetchEventCFQ(at index: Int, cfqUID: String) {
        
        firebaseService.getDataByID(from: .cfqs, with: cfqUID) { [weak self] (result: Result<CFQ, Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let event):
                
                print("@@@ \(String(describing: event.printObject))")
                // Assurez-vous que l'index est toujours valide
                
                // guard index < self.turns.count else { return }
                
                // Important: Sur le thread principal pour les UI updates
                DispatchQueue.main.async {
                    // Créez une copie du tableau entier pour déclencher le changement observable
                   //  let updatedTurns = self.turns
                    // updatedTurns[index].adminContact = adminContact
                    
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    //self.turns = updatedTurns
                    
                    
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
    
    
    func fetchEventTurn(at index: Int, turnUID: String) {
        print("@@@ yes")
        firebaseService.getDataByID(from: .turns, with: turnUID) { [weak self] (result: Result<Turn, Error>) in
            guard self != nil else { return }
            
            switch result {
            case .success(let event):
                
                print("@@@ \(String(describing: event.printObject))")
                // Assurez-vous que l'index est toujours valide
                
                // guard index < self.turns.count else { return }
                
                // Important: Sur le thread principal pour les UI updates
                DispatchQueue.main.async {
                    // Créez une copie du tableau entier pour déclencher le changement observable
                   //  let updatedTurns = self.turns
                    // updatedTurns[index].adminContact = adminContact
                    
                    // Remplacez tout le tableau pour que SwiftUI détecte le changement
                    //self.turns = updatedTurns
                    
                    
                }
                
            case .failure(let error):
                Logger.log(error.localizedDescription, level: .error)
            }
        }
    }
}
