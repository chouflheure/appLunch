
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
                case .failure(let error):
                    print("@@@ here")
                    Logger.log(error.localizedDescription, level: .error)
                }
            }
    }
}
