
import Firebase

enum CollectionFirebaseEnum: String {
    case users = "users"
    case turns = "turns"
    case cfqs = "cfqs"
    case teams = "teams"
    case notifications = "notifiations"
    case conversations = "conversations"
}

// TODO:
// Select Data By ID
// Delete Data By ID
// Update Data By ID
// Update if let uid = (data as? User)?.uid ?? (data as? Turn)?.uid avec tous les CollectionFirebaseEnum
// Rename CollectionFirebaseEnum

protocol FirebaseServiceProtocol {
    func addData<T: Codable>(data: T, to collection: CollectionFirebaseEnum)
    func updateData<T: Codable>(data: T, to collection: CollectionFirebaseEnum, with id: String)
    func getAllData<T: Codable>(from collection: CollectionFirebaseEnum, completion: @escaping (Result<[T], Error>) -> Void)
}

class FirebaseService: FirebaseServiceProtocol {

    let db = Firestore.firestore()

    // Méthode générique pour ajouter un objet de n'importe quel type conforme à Codable
    func addData<T: Codable>(data: T, to collection: CollectionFirebaseEnum) {
        do {
            let collectionName = collection.rawValue

            if let uid = (data as? User)?.uid ?? (data as? Turn)?.uid {
                try db.collection(collectionName).document(uid).setData(from: data) { error in
                    if let error = error {
                        Logger.log(" Erreur lors de l'ajout de \(collection.rawValue) : \(error.localizedDescription)", level: .error)
                    } else {
                        Logger.log("\(collection.rawValue) a été ajouté avec success", level: .success)
                    }
                }
            } else {
                Logger.log("Erreur : Impossible de récupérer l'identifiant de l'objet", level: .error)
            }
        } catch {
            Logger.log("Erreur de conversion des données : \(error.localizedDescription)", level: .error)
        }
    }
    
    // Méthode générique pour editer un objet de n'importe quel type conforme à Codable
    func updateData<T: Codable>(data: T, to collection: CollectionFirebaseEnum, with id: String) {
        do {
            let collectionName = collection.rawValue

            if let uid = (data as? User)?.uid ?? (data as? Turn)?.uid {
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
    
    // Méthode générique pour récupérer toutes les données d'une collection
    func getAllData<T: Codable>(from collection: CollectionFirebaseEnum, completion: @escaping (Result<[T], Error>) -> Void) {
        let collectionName = collection.rawValue
        
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let snapshot = snapshot else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Snapshot non disponible."])))
                return
            }
            
            var dataArray: [T] = []
            
            // Parcours des documents récupérés et décodage des données
            for document in snapshot.documents {
                do {
                    // On décode chaque document dans un objet de type T
                    let data = try document.data(as: T.self)
                    dataArray.append(data)
                } catch {
                    completion(.failure(error))
                    return
                }
            }
            
            // Retourne les données sous forme de tableau
            completion(.success(dataArray))
        }
    }
}
