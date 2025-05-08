
import Foundation

class FeedViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    var turnsID = ["FP5UQvLXVpuSt8N0b9ML", "9BB80E71-84B3-4503-90E8-470836A22FB7"]
    @Published var turns: [Turn] = []
        

    init() {
        print("@@@ init")
        startListeningToTeams()
    }

    
    func startListeningToTeams() {
        firebaseService.getDataByIDs(
            from: .turns,
            with: turnsID,
            listenerKeyPrefix: ListenerType.team_group_listener.rawValue
        ){ [weak self] (result: Result<[Turn], Error>) in
                switch result {
                case .success(let turns):
                    self?.turns = turns
                    print("@@@ sucess = \(turns[0].printObject)")
                case .failure(let error):
                    print("@@@ here")
                    print("❌ Erreur : \(error.localizedDescription)")
                }
            }
    }
    
    
    func catchTurns() {
        firebaseService.getDataByID(from: .turns, with: "FP5UQvLXVpuSt8N0b9ML") { (result: Result<Turn, Error>) in
            switch result {
            case .success(let turn):
                DispatchQueue.main.async {
                    self.turns.append(turn)
                    print(turn.printObject)
                }
            case .failure(let e):
                print("@@@ \(e)")
            }
        }
    }
        
    
}


/*
Turn(uid: "1", titleEvent: "Test", date: nil, pictureURLString: "", admin: "Test", description: "test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.2, placeLongitude: 1.2),
Turn(uid: "2", titleEvent: "Tomoroland", date: nil, pictureURLString: "", admin: "Tomoroland", description: "Tomoroland Tomoroland Tomoroland TomorolandTomorolandTomorolandTomoroland TomorolandTomoroland TomorolandTomoroland TomorolandTomoroland st Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.2, placeLongitude: 1.2)]
*/
