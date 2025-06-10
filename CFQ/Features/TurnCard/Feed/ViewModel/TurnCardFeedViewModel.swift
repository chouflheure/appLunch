
import SwiftUI
import Firebase

class TurnCardFeedViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    
    func addStatusUserOnTurn(userUID: String, turn: Turn, status: TypeParticipateButton) {
        
        switch status {
        case .yes:
            turn.participants.append(userUID)
        case .maybe:
            turn.mayBeParticipate.append(userUID)
        case .no:
            turn.denied.append(userUID)
        case .none:
            break
        }
        
        print("@@@ here")
/*
        firebaseService.updateDataByID (
            data: [
                "messagesChannelId": FieldValue.arrayUnion([turn.messagerieUUID]),
                "postedTurns": FieldValue.arrayUnion([turn.uid])
            ],
            to: .users,
            at: turn.admin
        )
 */
    }
}
