
import Foundation
import FirebaseFirestore

class TeamListScreenViewModel: ObservableObject {
    var firebaseService = FirebaseService()
    @Published var teams = [Team]()

    // @EnvironmentObject var user: User
    var user = User(
        uid: "1234567890",
        name: "John",
        firstName: "Doe",
        pseudo: "johndoe",
        location: ["Ici"],
        teams: ["test", "Test", "4A5DD7E4-32EB-42EB-B8A0-E48A1609384C", "42734BB3-074E-488C-8FAB-A83A700CD446"]
    )

    init() {
        startListeningToTeams()
    }

    func startListeningToTeams() {
        firebaseService.getDataByIDs(
            from: .teams,
            with: user.teams ?? [""],
            listenerKeyPrefix: .team_group_listener){ (result: Result<[Team], Error>) in
            
                switch result {
                case .success(let teams):
                    print("✅ \(teams.count) teams à jour !")
                    self.teams = teams
                    teams.forEach { print($0.title) }
                case .failure(let error):
                    print("❌ Erreur : \(error.localizedDescription)")
                }
            }
    }
    
    func fetchListTeam(completion: @escaping (Bool, String) -> Void) {
        firebaseService.getDataByIDs(from: .teams, with: ["test"]) { (result: Result<[Team], Error>) in
            switch result {
            case .success(let team):
                DispatchQueue.main.async {
                    completion(true, "test message")
                }
            case .failure( let e):
                print("@@@ error = \(e)")
                completion(false, "test message error = \(e)")
            }
        }
    }
}


import FirebaseFirestore


class FirestoreServiceTest {
    // static let shared = FirestoreService() // Singleton global
    let db = Firestore.firestore()

    private var listeners: [String: ListenerRegistration] = [:]

    /// Commence à écouter un document spécifique de Firestore et retourne un objet typé via Codable
    func listenToDocumentByID<T: Codable>(
        from collection: CollectionFirebaseType,
        with id: String,
        listenerKey: String? = nil, // facultatif, pour référencer ce listener
        onUpdate: @escaping (Result<T, Error>) -> Void
    ) {
        let collectionName = collection.rawValue
        let documentRef = db.collection(collectionName).document(id)

        let registration = documentRef.addSnapshotListener { documentSnapshot, error in
            if let error = error {
                onUpdate(.failure(error))
                return
            }

            guard let document = documentSnapshot, document.exists else {
                onUpdate(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Document non trouvé."])))
                return
            }

            do {
                let data = try document.data(as: T.self)
                onUpdate(.success(data))
            } catch {
                onUpdate(.failure(error))
            }
        }

        // Optionnel : enregistrer le listener pour pouvoir l’arrêter plus tard
        if let key = listenerKey {
            listeners[key] = registration
        }
    }
    
    func listenToDocumentsByIDs<T: Codable>(
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
            }
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
