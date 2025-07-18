import SwiftUI

class ConversationOptionCFQViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    
    func updateUserOnCFQ(cfq: CFQ, usersUUID: [String], admin: User?, completion: @escaping (Bool, String) -> Void?) {
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
                self.addCFQToNewUser(usersUUID: usersUUID, cfq: cfq, admin: admin)
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    private func addCFQToNewUser(usersUUID: [String], cfq: CFQ, admin: User) {
        firebaseService.updateDataByIDs(
            data: ["invitedCfqs": cfq.uid],
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
