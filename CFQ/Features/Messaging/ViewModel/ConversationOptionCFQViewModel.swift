import SwiftUI

class ConversationOptionCFQViewModel: ObservableObject {
    private var firebaseService = FirebaseService()
    
    func updateUserOnCFQ(cfqUUID: String, usersUUID: String, completion: @escaping (Bool, String) -> Void  ) {
        firebaseService.updateDataByID(
            data: ["users": usersUUID],
            to: .cfqs,
            at: cfqUUID
        ) {
            result in
            switch result {
            case .success():
                completion(true, "")
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
