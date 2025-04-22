
import Firebase
import FirebaseStorage

enum ListenerType: String {
    case team_group_listener = "team_group_listener"
    case team_user = "team_user"
}

class FirebaseService: FirebaseServiceProtocol {
    private var listeners: [String: ListenerRegistration] = [:]
    let db = Firestore.firestore()

    func addData<T: Codable>(data: T, to collection: CollectionFirebaseType, completion: @escaping (Result<Void, Error>) -> (Void)) {
        do {
            let collectionName = collection.rawValue

            if let uid = (data as? User)?.uid ??
                (data as? Turn)?.uid ??
                (data as? Conversation)?.uid ??
                (data as? Notification)?.uid ??
                (data as? Team)?.uid ??
                (data as? CFQ)?.uid
            {
                try db.collection(collectionName).document(uid).setData(from: data) { error in
                    if let error = error {
                        completion(.failure(error))
                        Logger.log(" Erreur lors de l'ajout de \(collection.rawValue) : \(error.localizedDescription)", level: .error)
                    } else {
                        completion(.success(Void()))
                        Logger.log("\(collection.rawValue) a été ajouté avec success", level: .success)
                    }
                }
            } else {
                Logger.log("Erreur : Impossible de récupérer l'identifiant de l'objet", level: .error)
            }
        } catch {
            completion(.failure(error))
            Logger.log("Erreur de conversion des données : \(error.localizedDescription)", level: .error)
        }
    }

    func updateDataByID(data: [String: Any], to collection: CollectionFirebaseType, at id: String) {
        let collectionName = collection.rawValue

        db.collection(collectionName).document(id).updateData(data) { error in
            if let error = error {
                Logger.log("Erreur lors de la modification de \(collection.rawValue) : \(error.localizedDescription)", level: .error)
            } else {
                Logger.log("\(collection.rawValue) a été modifié avec succès", level: .success)
            }
        }
    }

    
    func deleteDataByID(from collection: CollectionFirebaseType, at id: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let collectionName = collection.rawValue

        db.collection(collectionName).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func getDataByID<T: Codable>(from collection: CollectionFirebaseType, with id: String, completion: @escaping (Result<T, Error>) -> Void) {
        let collectionName = collection.rawValue

        db.collection(collectionName).document(id).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document non trouvé."])))
                return
            }
            
            do {
                let data = try document.data(as: T.self)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
    }

    func getDataByIDs<T: Codable>(
        from collection: CollectionFirebaseType,
        with ids: [String],
        listenerKeyPrefix: String? = nil,
        onUpdate: @escaping (Result<[T], Error>) -> Void
    ) {
        let collectionName = collection.rawValue
        var currentData: [String: T] = [:]
        var firstLoadCompleted = Set<String>() // Pour ne notifier que quand tous les premiers loads sont faits

        for id in ids {
            let documentRef = db.collection(collectionName).document(id)

            let registration = documentRef.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    onUpdate(.failure(error))
                    return
                }

                guard let document = documentSnapshot, document.exists else {
                    onUpdate(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document \(id) non trouvé."])))
                    return
                }

                do {
                    let data = try document.data(as: T.self)
                    currentData[id] = data
                    firstLoadCompleted.insert(id)

                    // Si tous les documents ont été chargés au moins une fois, on peut émettre le tableau
                    if firstLoadCompleted.count == ids.count {
                        let orderedResults = ids.compactMap { currentData[$0] }
                        onUpdate(.success(orderedResults))
                    }

                } catch {
                    onUpdate(.failure(error))
                }
            }

            // Stocke le listener si un préfixe est fourni
            if let keyPrefix = listenerKeyPrefix {
                let key = "\(keyPrefix)_\(id)"
                listeners[key] = registration
            } else {
                print("@@@ NOP")
            }
        }
    }
    
/*
    func getDataByIDs<T: Codable>(from collection: CollectionFirebaseType, with ids: [String], completion: @escaping (Result<[T], Error>) -> Void) {
        let collectionName = collection.rawValue
            let dispatchGroup = DispatchGroup()
            var results: [T] = []
            var errors: [Error] = []

            for id in ids {
                dispatchGroup.enter()
                db.collection(collectionName).document(id).getDocument { document, error in
                    if let error = error {
                        errors.append(error)
                        dispatchGroup.leave()
                        return
                    }

                    guard let document = document, document.exists else {
                        errors.append(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document non trouvé pour l'ID \(id)."]))
                        dispatchGroup.leave()
                        return
                    }

                    do {
                        let data = try document.data(as: T.self)
                        results.append(data)
                        dispatchGroup.leave()
                    } catch {
                        errors.append(error)
                        dispatchGroup.leave()
                    }
                }
            }

            dispatchGroup.notify(queue: .main) {
                if !errors.isEmpty {
                    completion(.failure(errors.first!)) // Vous pouvez choisir de renvoyer la première erreur ou de créer une erreur composite
                } else {
                    completion(.success(results))
                }
            }
    }
*/
    
    func getAllData<T: Codable>(from collection: CollectionFirebaseType, completion: @escaping (Result<[T], Error>) -> Void) {
        let collectionName = collection.rawValue
        var dataArray: [T] = []

        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot non disponible."])))
                return
            }
            
            for document in snapshot.documents {
                do {
                    let data = try document.data(as: T.self)
                    dataArray.append(data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }

            completion(.success(dataArray))
        }
    }

    /// Pour arrêter un listener
    func removeListener(for key: String) {
        listeners[key]?.remove()
        listeners.removeValue(forKey: key)
    }

    /// Pour les arrêter tous (par ex. à la déconnexion)
    func removeAllListeners() {
        listeners.values.forEach { $0.remove() }
        listeners.removeAll()
    }
}


enum ImageUploadError: Error {
    case imageConversionFailed
    case uploadFailed(Error)
    // Ajoutez d'autres cas d'erreur si nécessaire
}


// Firebase Storage
extension FirebaseService {
    
    func uploadImage(picture: UIImage, uidUser: String, completion: @escaping (Result<String, Error>) -> Void ) {
        guard let imageData = picture.jpegData(compressionQuality: 0.8) else {
            completion(.failure(ImageUploadError.imageConversionFailed))
            return
        }

        let storageRef = Storage.storage().reference().child("images/\(uidUser).jpg")
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }

                if let url = url {
                    print("@@ Download URL: \(url.absoluteString)")
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}


extension FirebaseService {
/*
    // Modifiez la fonction getDataByIDs pour inclure un callback supplémentaire
    func getDataByIDs<T: Codable>(
        from collection: CollectionFirebaseType,
        with ids: [String],
        listenerKeyPrefix: ListenerType? = nil,
        onUpdate: @escaping (Result<[T], Error>) -> Void,
        onAllDataFetched: @escaping (Result<[T], Error>) -> Void // Nouveau callback
    ) {
        let collectionName = collection.rawValue
        var currentData: [String: T] = [:]
        var firstLoadCompleted = Set<String>()

        for id in ids {
            let documentRef = db.collection(collectionName).document(id)

            let registration = documentRef.addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    onUpdate(.failure(error))
                    return
                }

                guard let document = documentSnapshot, document.exists else {
                    onUpdate(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document \(id) non trouvé."])))
                    return
                }

                do {
                    let data = try document.data(as: T.self)
                    currentData[id] = data
                    firstLoadCompleted.insert(id)

                    if firstLoadCompleted.count == ids.count {
                        let orderedResults = ids.compactMap { currentData[$0] }
                        onUpdate(.success(orderedResults))
                        onAllDataFetched(.success(orderedResults)) // Appeler le nouveau callback
                    }

                } catch {
                    onUpdate(.failure(error))
                }
            }

            if let keyPrefix = listenerKeyPrefix {
                let key = "\(keyPrefix)_\(id)"
                listeners[key] = registration
            }
        }
    }

    // Utilisation de la fonction pour récupérer les équipes et les utilisateurs
    func fetchTeamsAndUsers(ids: [String]) {
        getDataByIDs(from: .teams, with: ids, onUpdate: { (result: Result<[Team], Error>) in
            switch result {
            case .success(let teams):
                // Transformer les teams en TeamGlobal
                for team in teams {
                    var teamGlobal = TeamGlobal(uid: team.uid, title: team.title, pictureUrlString: team.pictureUrlString, friends: [], admins: team.admins)

                    // Récupérer les utilisateurs pour chaque équipe
                    fetchUsers(with: team.friends) { (userResult: Result<[UserContact], Error>) in
                        switch userResult {
                        case .success(let users):
                            teamGlobal.friends = users
                            // Vous pouvez maintenant utiliser teamGlobal avec les utilisateurs récupérés
                            print(teamGlobal)
                        case .failure(let error):
                            print("Erreur lors de la récupération des utilisateurs : \(error)")
                        }
                    }
                }
            case .failure(let error):
                print("Erreur lors de la récupération des équipes : \(error)")
            }
        }, onAllDataFetched: { _ in })
    }

    // Fonction pour récupérer les utilisateurs
    func fetchUsers(with ids: [String], completion: @escaping (Result<[UserContact], Error>) -> Void) {
        getDataByIDs(from: .usersPreviews, with: ids, onUpdate: { (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let users):
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }, onAllDataFetched: { _ in })
    }
*/

}
