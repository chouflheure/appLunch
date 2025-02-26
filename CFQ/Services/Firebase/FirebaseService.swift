
import Firebase

class FirebaseService: FirebaseServiceProtocol {
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

    func updateDataByID<T>(data: T, to collection: CollectionFirebaseType, at id: String) where T : Decodable, T : Encodable {
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
                        Logger.log(" Erreur lors de la nodification de \(collection.rawValue) : \(error.localizedDescription)", level: .error)
                    } else {
                        Logger.log("\(collection.rawValue) a été modifié avec success", level: .success)
                    }
                }
            } else {
                Logger.log("Erreur : Impossible de récupérer l'identifiant de l'objet", level: .error)
            }
        } catch {
            Logger.log("Erreur de conversion des données : \(error.localizedDescription)", level: .error)
        }
    }
    
    func deleteDataByID(from collection: CollectionFirebaseType, with id: String, completion: @escaping (Result<Void, Error>) -> Void) {
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
}
