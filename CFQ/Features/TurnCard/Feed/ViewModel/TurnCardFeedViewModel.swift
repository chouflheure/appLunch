
import SwiftUI
import Firebase

class TurnCardFeedViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    private var data = [String : FieldValue]()
    
    func addStatusUserOnTurn(userUID: String, turn: Turn, status: TypeParticipateButton) {
        
        switch status {
        case .yes:
            data = [
                "denied": FieldValue.arrayRemove([userUID]),
                "mayBeParticipate" : FieldValue.arrayRemove([userUID]),
                "participants": FieldValue.arrayUnion([userUID]),
            ]
        case .maybe:
            data = [
                "denied": FieldValue.arrayRemove([userUID]),
                "mayBeParticipate" : FieldValue.arrayUnion([userUID]),
                "participants": FieldValue.arrayRemove([userUID]),
            ]
        case .no:
            data = [
                "denied": FieldValue.arrayUnion([userUID]),
                "mayBeParticipate" : FieldValue.arrayRemove([userUID]),
                "participants": FieldValue.arrayRemove([userUID]),
            ]
        case .none:
            break
        }
        
        print("@@@ here")
        firebaseService.updateDataByID (
            data: data,
            to: .turns,
            at: turn.uid
        )
    }
}
