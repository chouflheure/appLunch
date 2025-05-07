
import Foundation

class FeedViewModel {
    var firebaseService = FirebaseService()
    var turns = [
        Turn(uid: "1", titleEvent: "Test", date: nil, pictureURLString: "", admin: "Test", description: "test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.2, placeLongitude: 1.2),
        Turn(uid: "2", titleEvent: "Tomoroland", date: nil, pictureURLString: "", admin: "Tomoroland", description: "Tomoroland Tomoroland Tomoroland TomorolandTomorolandTomorolandTomoroland TomorolandTomoroland TomorolandTomoroland TomorolandTomoroland st Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test Test", invited: [""], participants: [""], mood: [0], messagerieUUID: "", placeTitle: "", placeAdresse: "", placeLatitude: 1.2, placeLongitude: 1.2)]

    func catchTurns() {
        firebaseService.getDataByID(from: .turns, with: "FP5UQvLXVpuSt8N0b9ML") { (result: Result<Turn, Error>) in
            switch result {
            case .success(let turn):
                DispatchQueue.main.async {
                    // self.turns.append(turn)
                    // print(turn.printObject)
                }
            case .failure(let e):
                print("@@@ \(e)")
            }
        }
    }
        
    
}
