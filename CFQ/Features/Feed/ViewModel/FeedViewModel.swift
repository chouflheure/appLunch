
import Foundation

class FeedViewModel {
    var firebaseService = FirebaseService()
    var turns = [Turn]()

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
