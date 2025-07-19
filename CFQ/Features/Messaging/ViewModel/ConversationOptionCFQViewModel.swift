import SwiftUI
import Firebase

class ConversationOptionCFQViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    
    func updateUserOnCFQ(
        cfq: CFQ,
        usersUUID: [String],
        friendUUIDBeforeModification: [String],
        admin: User?,
        completion: @escaping (Bool, String) -> Void?)
    {
        guard let admin = admin else {
            completion(true, "")
            return
        }

        firebaseService.updateDataByID(
            data: ["users": usersUUID],
            to: .cfqs,
            at: cfq.uid
        ) {
            result in
            switch result {
            case .success():
                self.removeUsers(
                    usersUUID: friendUUIDBeforeModification.filter { !usersUUID.contains($0) },
                    cfq: cfq,
                    admin: admin
                )
                
                self.addCFQToNewUser(
                    usersUUID: usersUUID.filter { !friendUUIDBeforeModification.contains($0) },
                    cfq: cfq,
                    admin: admin
                )
                
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
         
    }
    
    private func removeUsers(usersUUID: [String], cfq: CFQ, admin: User) {
        firebaseService.updateDataByIDs(
            data: [
                "invitedCfqs": FieldValue.arrayRemove([cfq.uid]),
                "messagesChannelId": FieldValue.arrayRemove([cfq.messagerieUUID])
            ],
            to: .users,
            at: usersUUID
        )
    }
    
    private func addCFQToNewUser(usersUUID: [String], cfq: CFQ, admin: User) {
        firebaseService.updateDataByIDs(
            data: [
                "invitedCfqs": FieldValue.arrayUnion([cfq.uid]),
                "messagesChannelId": FieldValue.arrayUnion([cfq.messagerieUUID])
            ],
            to: .users,
            at: usersUUID
        )
        
        let uidNotification = UUID()
        
        firebaseService.addDataNotif(
            data: Notification(
                uid: uidNotification.description,
                typeNotif: .cfqCreated,
                timestamp: Date(),
                uidUserNotif: admin.uid,
                uidEvent: cfq.uid,
                titleEvent: cfq.title,
                userInitNotifPseudo: admin.pseudo
            ),
            userNotifications: usersUUID,
            completion: {_ in }
        )
    }
    
    private func addCFQToNewUser(usersUUID: [String], cfqUUID: String) {
        firebaseService.updateDataByIDs(
            data: ["invitedCfqs": cfqUUID],
            to: .users,
            at: usersUUID
        )
    }
}
