
class PopUpSettingsViewModel {
        
    private var firebase = FirebaseService()
    
    func removeUserFromDataBase(uidUser: String, completion: @escaping (Bool, Error?) -> Void) {
        firebase.deleteDataByID(from: .users, at: uidUser) { result in
            switch result {
            case .success(()):
                return completion(true, nil)
            case .failure(let error):
                return completion(false, error)
            }
        }
    }
}
