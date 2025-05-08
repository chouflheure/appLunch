
import Foundation

class FeedViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    var turnsID = ["FP5UQvLXVpuSt8N0b9ML", "9BB80E71-84B3-4503-90E8-470836A22FB7", "DC77FECA-B535-4CBF-81F7-C9D09FA32049", "F2D2CE38-0C1E-44E7-ABFA-FF9C588676CB"]
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
