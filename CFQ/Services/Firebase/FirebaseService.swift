import Firebase
import FirebaseStorage
import Network

enum ListenerType: String {
    case team_group_listener = "team_group_listener"
    case team_user = "team_user"
    case friends = "friends"
    case cfq = "cfq"
    case turn = "turn"
    case conversation = "conversation"
    case notification = "notification"
    case user = "user"
}

// TODO: - Update call firebase
// https://claude.ai/chat/91dee304-c7de-43cd-a448-93a5933d73d3

class FirebaseService: FirebaseServiceProtocol {
    private var listeners: [String: ListenerRegistration] = [:]
    let db = Firestore.firestore()

    
    func searchUsers(with query: String) {
            // Assurez-vous que la requête n'est pas vide
            guard !query.isEmpty else { return }

            // Effectuer la recherche dans Firestore
            db.collection("users")
                .whereField("pseudo", isGreaterThanOrEqualTo: query)
                .whereField("pseudo", isLessThanOrEqualTo: query + "\u{f8ff}")
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Erreur lors de la recherche d'utilisateurs : \(error.localizedDescription)")
                        return
                    }

                    // Traiter les documents retournés
                    for document in querySnapshot?.documents ?? [] {
                        let userData = document.data()
                        print("Utilisateur trouvé : \(userData)")
                        // Traiter les données de l'utilisateur comme nécessaire
                    }
                }
        }
    
    func addData<T: Codable>(
        data: T, to collection: CollectionFirebaseType,
        completion: @escaping (Result<Void, Error>) -> (Void)
    ) {
        do {
            let collectionName = collection.rawValue

            if let uid = (data as? User)?.uid ?? (data as? Turn)?.uid
                ?? (data as? Conversation)?.uid ?? (data as? Notification)?.uid
                ?? (data as? Team)?.uid ?? (data as? CFQ)?.uid
            {
                try db.collection(collectionName).document(uid).setData(
                    from: data
                ) { error in
                    if let error = error {
                        completion(.failure(error))
                        Logger.log(
                            " Erreur lors de l'ajout de \(collection.rawValue) : \(error.localizedDescription)",
                            level: .error)
                    } else {
                        completion(.success(Void()))
                        Logger.log(
                            "\(collection.rawValue) a été ajouté avec success",
                            level: .success)
                    }
                }
            } else {
                Logger.log(
                    "Erreur : Impossible de récupérer l'identifiant de l'objet",
                    level: .error)
            }
        } catch {
            completion(.failure(error))
            Logger.log(
                "Erreur de conversion des données : \(error.localizedDescription)",
                level: .error)
        }
    }

    func updateDataByID(
        data: [String: Any],
        to collection: CollectionFirebaseType,
        at id: String,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        let collectionName = collection.rawValue
        db.collection(collectionName).document(id).updateData(data) { error in
            if let error = error {
                Logger.log(
                    "Erreur lors de la modification de \(collection.rawValue) : \(error.localizedDescription)",
                    level: .error)
                completion?(.failure(error))
            } else {
                Logger.log(
                    "\(collection.rawValue) a été modifié avec succès",
                    level: .success)
                completion?(.success(()))
            }
        }
    }

    func updateDataByIDs(
        data: [String: Any],
        to collection: CollectionFirebaseType,
        at ids: [String]
    ) {
        let collectionName = collection.rawValue

        for id in ids {
            db.collection(collectionName).document(id).updateData(data) { error in
                if let error = error {
                    Logger.log(
                        "Erreur lors de la modification de \(collection.rawValue) pour l'ID \(id) : \(error.localizedDescription)",
                        level: .error)
                } else {
                    Logger.log(
                        "\(collection.rawValue) avec l'ID \(id) a été modifié avec succès",
                        level: .success)
                }
            }
        }
    }

    func deleteDataByID(
        from collection: CollectionFirebaseType, at id: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let collectionName = collection.rawValue

        db.collection(collectionName).document(id).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }

    func getDataByID<T: Codable>(
        from collection: CollectionFirebaseType, with id: String,
        listenerKeyPrefix: String? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> ListenerRegistration? {
        let collectionName = collection.rawValue

        if let keyPrefix = listenerKeyPrefix {
            let listener = db.collection(collectionName).document(id).addSnapshotListener { documentSnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = documentSnapshot, document.exists else {
                    completion(
                        .failure(
                            NSError(
                                domain: "", code: 0,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Document non trouvé."
                                ])))
                    return
                }

                do {
                    let data = try document.data(as: T.self)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }

            // Stocke le listener si un préfixe est fourni
            let key = "\(keyPrefix)_\(id)"
            listeners[key] = listener
            return listener
        } else {
            db.collection(collectionName).document(id).getDocument { document, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let document = document, document.exists else {
                    completion(
                        .failure(
                            NSError(
                                domain: "", code: 0,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Document non trouvé."
                                ])))
                    return
                }

                do {
                    let data = try document.data(as: T.self)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            }
            return nil
        }
    }

    func getDataByIDs<T: Codable>(
        from collection: CollectionFirebaseType,
        with ids: [String],
        listenerKeyPrefix: String? = nil,
        onUpdate: @escaping (Result<[T], Error>) -> Void,
        onInvalidIds: ((Set<String>) -> Void)? = nil  // Nouveau callback pour les IDs invalides
    ) {
        let collectionName = collection.rawValue
        var currentData: [String: T] = [:]
        var firstLoadCompleted = Set<String>()
        var invalidIds = Set<String>()  // Set pour stocker les IDs invalides
        var processedIds = Set<String>()  // Pour suivre quels IDs ont été traités
        
        guard !ids.isEmpty else {
            onUpdate(.success([]))
            return
        }

        for id in ids {
            let documentRef = db.collection(collectionName).document(id)

            let registration = documentRef.addSnapshotListener { [weak self]
                documentSnapshot, error in
                
                // Marquer cet ID comme traité
                processedIds.insert(id)
                
                if let error = error {
                    print("❌ Error listening to document \(id): \(error.localizedDescription)")
                    invalidIds.insert(id)
                } else if let document = documentSnapshot, document.exists {
                    // Document existe et est valide
                    do {
                        let data = try document.data(as: T.self)
                        currentData[id] = data
                        firstLoadCompleted.insert(id)
                        print("✅ Document \(id) loaded successfully")
                    } catch {
                        print("❌ Error decoding document \(id): \(error.localizedDescription)")
                        invalidIds.insert(id)
                    }
                } else {
                    // Document n'existe pas
                    print("📭 Document \(id) not found")
                    invalidIds.insert(id)
                }

                // Vérifier si tous les IDs ont été traités
                if processedIds.count == ids.count {
                    // Tous les documents ont été traités
                    
                    // Émettre les IDs invalides si le callback est fourni
                    if !invalidIds.isEmpty {
                        print("🧹 Found \(invalidIds.count) invalid document IDs: \(invalidIds)")
                        onInvalidIds?(invalidIds)
                    }
                    
                    // Émettre les résultats valides dans l'ordre original
                    let orderedResults = ids.compactMap { currentData[$0] }
                    print("📊 Successfully loaded \(orderedResults.count)/\(ids.count) documents")
                    print("📊 Successfully loaded \(orderedResults.forEach({$0}))")
                    onUpdate(.success(orderedResults))
                }
            }

            // Stocke le listener si un préfixe est fourni
            if let keyPrefix = listenerKeyPrefix {
                let key = "\(keyPrefix)_\(id)"
                listeners[key] = registration
            }
        }
    }
    
    func getUsersByPhoneNumbersBatch<T: Codable>(
        from collection: CollectionFirebaseType,
        phoneNumbers: [String],
        onUpdate: @escaping (Result<[T], Error>) -> Void,
        onInvalidPhones: ((Set<String>) -> Void)? = nil
    ) {
        let collectionName = collection.rawValue
        
        guard !phoneNumbers.isEmpty else {
            onUpdate(.success([]))
            return
        }
        
        print("🔍 Batch searching for users with \(phoneNumbers.count) phone numbers")
        
        // Normaliser les numéros
        let normalizedPhones = phoneNumbers.map { phone in
            phone.replacingOccurrences(of: " ", with: "")
        }
        
        // Firestore limite les requêtes "in" à 10 éléments max
        let chunks = normalizedPhones.chunked(into: 10)
        var allFoundUsers: [T] = []
        var allInvalidPhones = Set<String>()
        var processedChunks = 0
        
        for chunk in chunks {
            let query = db.collection(collectionName)
                .whereField("phoneNumber", in: chunk)
            
            query.getDocuments { querySnapshot, error in
                processedChunks += 1
                
                if let error = error {
                    print("❌ Error in batch query: \(error.localizedDescription)")
                    allInvalidPhones.formUnion(chunk)
                } else if let snapshot = querySnapshot {
                    var foundPhonesInChunk = Set<String>()
                    
                    for document in snapshot.documents {
                        do {
                            let userData = try document.data(as: T.self)
                            allFoundUsers.append(userData)
                            
                            // Récupérer le numéro de téléphone du document
                            if let userPhone = document.data()["phoneNumber"] as? String {
                                foundPhonesInChunk.insert(userPhone)
                            }
                            
                            print("✅ User found: \(document.documentID)")
                        } catch {
                            print("❌ Error decoding user: \(error.localizedDescription)")
                        }
                    }
                    
                    // Identifier les numéros non trouvés dans ce chunk
                    let notFoundInChunk = Set(chunk).subtracting(foundPhonesInChunk)
                    allInvalidPhones.formUnion(notFoundInChunk)
                }
                
                // Vérifier si tous les chunks ont été traités
                if processedChunks == chunks.count {
                    if !allInvalidPhones.isEmpty {
                        print("📱 Phone numbers without users: \(allInvalidPhones.count)")
                        onInvalidPhones?(allInvalidPhones)
                    }
                    
                    print("📊 Batch search completed: \(allFoundUsers.count) users found")
                    onUpdate(.success(allFoundUsers))
                }
            }
        }
    }
    
    
    
    /*
    func getDataByIDs<T: Codable>(
        from collection: CollectionFirebaseType,
        with ids: [String],
        listenerKeyPrefix: String? = nil,
        onUpdate: @escaping (Result<[T], Error>) -> Void
    ) {
        let collectionName = collection.rawValue
        var currentData: [String: T] = [:]
        var firstLoadCompleted = Set<String>()  // Pour ne notifier que quand tous les premiers loads sont faits

        for id in ids {
            let documentRef = db.collection(collectionName).document(id)

            let registration = documentRef.addSnapshotListener {
                documentSnapshot, error in
                if let error = error {
                    onUpdate(.failure(error))
                    return
                }

                guard let document = documentSnapshot, document.exists else {
                    onUpdate(
                        .failure(
                            NSError(
                                domain: "", code: 0,
                                userInfo: [
                                    NSLocalizedDescriptionKey:
                                        "Document \(id) non trouvé."
                                ])))
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
*/

    func updateNotificationByIDs(
        data: [String: Any],
        at ids: [String]
    ) {
        for id in ids {
            db.collection("notifications").document(id).updateData(data) { error in
                if let error = error {
                    Logger.log(
                        "Erreur lors de la modification de notification pour l'ID \(id) : \(error.localizedDescription)",
                        level: .error)
                } else {
                    Logger.log(
                        "\notification avec l'ID \(id) a été modifié avec succès",
                        level: .success)
                }
            }
        }
    }
    
    
    func getNotificationsByIds(
        notificationUID: String,
        limit: Int = 15,
        // listenerKeyPrefix: String,
        completion: @escaping (Result<[Notification], Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let messagesRef = db.collection("notifications").document(notificationUID).collection("userNotifications")

        // Query pour récupérer les 15 derniers messages triés par timestamp
        let query =
            messagesRef
            .order(by: "timestamp", descending: true)  // Les plus récents d'abord
            .limit(to: limit)

        // Ajouter le listener
        let listener = query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                print("@@@ failure ")
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                print("@@@ success ")
                return
            }

            var notifications: [Notification] = []
            for document in documents {
                do {
                    let notification = try document.data(as: Notification.self)
                    notifications.append(notification)
                } catch {
                    print("Erreur de décodage du message: \(error)")
                }
            }

            // Inverser l'ordre pour avoir les plus anciens en premier (pour l'affichage)
            let sortedNotifications = notifications.reversed()
            completion(.success(Array(sortedNotifications)))
        }

        // Stocker le listener pour pouvoir le supprimer plus tard
        // activeListeners[listenerKeyPrefix] = listener
    }
    
    func addDataNotif(
        data: Notification,
        userNotifications: [String],
        completion: @escaping (Result<Void, Error>) -> Void?
    ) {
        let db = Firestore.firestore()
        let dispatchGroup = DispatchGroup()

        var encounteredError: Error?

        for userNotification in userNotifications {
            dispatchGroup.enter()

            do {
                try db.collection("notifications")
                    .document(userNotification)
                    .collection("userNotifications")
                    .addDocument(from: data) { error in
                        if let error = error {
                            encounteredError = error
                            Logger.log(
                                "Erreur lors de l'ajout de la notification pour \(userNotification) : \(error.localizedDescription)",
                                level: .error
                            )
                        } else {
                            Logger.log(
                                "Données ajoutées avec succès à notification pour \(userNotification)",
                                level: .info
                            )
                        }
                        dispatchGroup.leave()
                    }
            } catch {
                encounteredError = error
                Logger.log(
                    "Erreur de conversion des données pour \(userNotification) : \(error.localizedDescription)",
                    level: .error
                )
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            if let error = encounteredError {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getMessagesByIds(
        conversationID: String,
        limit: Int = 15,
        listenerKeyPrefix: String,
        completion: @escaping (Result<[Message], Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let messagesRef = db.collection("conversations")
            .document(conversationID)
            .collection("messages")

        // Query pour récupérer les 15 derniers messages triés par timestamp
        let query =
            messagesRef
            .order(by: "timestamp", descending: true)  // Les plus récents d'abord
            .limit(to: limit)

        // Ajouter le listener
        let listener = query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                print("@@@ failure ")
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                print("@@@ success ")
                return
            }

            var messages: [Message] = []
            for document in documents {
                do {
                    let message = try document.data(as: Message.self)
                    messages.append(message)
                } catch {
                    print("Erreur de décodage du message: \(error)")
                }
            }

            // Inverser l'ordre pour avoir les plus anciens en premier (pour l'affichage)
            let sortedMessages = messages.reversed()
            completion(.success(Array(sortedMessages)))
        }

        // Stocker le listener pour pouvoir le supprimer plus tard
        activeListeners[listenerKeyPrefix] = listener
    }

    func markMessageAsRead(conversationId: String, userId: String) {
        let conversationRef = db.collection("conversations").document(conversationId)

        // Utiliser arrayUnion pour ajouter l'userId s'il n'existe pas déjà
        conversationRef.updateData([
            "messageReader": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Erreur lors de la mise à jour: \(error)")
            } else {
                print("Utilisateur ajouté aux lecteurs")
            }
        }
        
        updateDataByID(
            data: ["arrayConversationUnread": FieldValue.arrayRemove([conversationId])],
            to: .users,
            at: userId
        )
    }

    private var activeListeners: [String: ListenerRegistration] = [:]

    func addMessage(
        data: Message,
        at conversationID: String,
        completion: @escaping (Result<Void, Error>) -> (Void)
    ) {
        do {
            try db.collection("conversations").document(conversationID)
                .collection("messages").document(data.uid).setData(from: data) {
                    error in
                    if let error = error {
                        completion(.failure(error))
                        Logger.log(
                            " Erreur lors de l'ajout du message : \(error.localizedDescription)",
                            level: .error)
                    } else {
                        completion(.success(Void()))
                        Logger.log(
                            "le message a été ajouté avec success",
                            level: .success)
                    }
                }

        } catch {
            completion(.failure(error))
            Logger.log(
                "Erreur de conversion des données : \(error.localizedDescription)",
                level: .error)
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

    func getAllData<T: Codable>(
        from collection: CollectionFirebaseType,
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        let collectionName = collection.rawValue
        var dataArray: [T] = []

        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let snapshot = snapshot else {
                completion(
                    .failure(
                        NSError(
                            domain: "", code: 0,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "Snapshot non disponible."
                            ])))
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
    
    // FONCTION 1: Miniatures de qualité acceptable (15KB max)
    func createThumbnail(_ image: UIImage) -> Data? {
        // Thumbnail raisonnable : 200x200 max
        let thumbnailSize: CGFloat = 200
        let ratio = min(thumbnailSize / image.size.width, thumbnailSize / image.size.height)
        let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0) // false = transparence si besoin
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let thumbnailImage = thumbnail else { return nil }
        
        // Compression progressive pour atteindre 15KB max avec qualité décente
        var compressionQuality: CGFloat = 0.7 // Commencer à 70% au lieu de 5%
        var imageData = thumbnailImage.jpegData(compressionQuality: compressionQuality)
        
        while let data = imageData, data.count > 15 * 1024 && compressionQuality > 0.3 {
            compressionQuality -= 0.1
            imageData = thumbnailImage.jpegData(compressionQuality: compressionQuality)
        }
        
        print("@@@ Thumbnail size: \(imageData?.count ?? 0) bytes, quality: \(compressionQuality)")
        return imageData
    }
    
    // FONCTION 2: Images optimisées de bonne qualité (50KB max)
    func optimizeImageStandard(_ image: UIImage) -> Data? {
        // ÉTAPE 1: Redimensionner à 800px max (au lieu de 512px)
        var workingImage = image
        let maxDimension: CGFloat = 800
        
        if image.size.width > maxDimension || image.size.height > maxDimension {
            let ratio = min(maxDimension / image.size.width, maxDimension / image.size.height)
            let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0) // Garder la transparence
            image.draw(in: CGRect(origin: .zero, size: newSize))
            workingImage = UIGraphicsGetImageFromCurrentImageContext() ?? image
            UIGraphicsEndImageContext()
        }
        
        // ÉTAPE 2: Si encore trop grande, redimensionner à 600px (au lieu de 256px)
        var currentData = workingImage.jpegData(compressionQuality: 0.8)
        if let data = currentData, data.count > 50 * 1024 {
            let mediumDimension: CGFloat = 600
            if workingImage.size.width > mediumDimension || workingImage.size.height > mediumDimension {
                let ratio = min(mediumDimension / workingImage.size.width, mediumDimension / workingImage.size.height)
                let newSize = CGSize(width: workingImage.size.width * ratio, height: workingImage.size.height * ratio)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                workingImage.draw(in: CGRect(origin: .zero, size: newSize))
                workingImage = UIGraphicsGetImageFromCurrentImageContext() ?? workingImage
                UIGraphicsEndImageContext()
            }
        }
        
        // ÉTAPE 3: Compression progressive avec qualité décente
        var compressionQuality: CGFloat = 0.8 // Commencer à 80%
        var imageData = workingImage.jpegData(compressionQuality: compressionQuality)
        
        while let data = imageData, data.count > 50 * 1024 && compressionQuality > 0.4 {
            compressionQuality -= 0.1
            imageData = workingImage.jpegData(compressionQuality: compressionQuality)
        }
        
        print("@@@ Standard image size: \(imageData?.count ?? 0) bytes, quality: \(compressionQuality)")
        return imageData
    }
    
    // FONCTION UPLOAD POUR MINIATURES (15KB)
    func uploadThumbnail(
        picture: UIImage,
        uidUser: String,
        localisationImage: LocalisationImages,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        print("@@@ uploadThumbnail in ")
        
        // Créer une miniature de 15KB max
        guard let imageData = createThumbnail(picture) else {
            print("@@@ error creating thumbnail")
            completion(.failure(ImageUploadError.imageConversionFailed))
            return
        }
        
        print("@@@ Thumbnail optimized, size: \(imageData.count) bytes")
        
        uploadImageData(imageData, uidUser: uidUser, localisationImage: localisationImage, suffix: "_thumb", completion: completion)
    }
    
    // FONCTION UPLOAD POUR IMAGES STANDARD (50KB)
    func uploadImageStandard(
        picture: UIImage,
        uidUser: String,
        localisationImage: LocalisationImages,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        print("@@@ uploadImageStandard in ")
        
        // Optimiser l'image à 50KB max
        guard let imageData = optimizeImageStandard(picture) else {
            print("@@@ error optimizing image")
            completion(.failure(ImageUploadError.imageConversionFailed))
            return
        }
        
        print("@@@ Image optimized, size: \(imageData.count) bytes")
        
        uploadImageData(imageData, uidUser: uidUser, localisationImage: localisationImage, suffix: "", completion: completion)
    }
    
    // FONCTION COMMUNE POUR L'UPLOAD
    private func uploadImageData(
        _ imageData: Data,
        uidUser: String,
        localisationImage: LocalisationImages,
        suffix: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        let monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        var hasConnection = false
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                hasConnection = true
            } else {
                hasConnection = false
                print("@@@ No internet connection")
                completion(
                    .failure(
                        NSError(
                            domain: "NoInternet", code: -1,
                            userInfo: [
                                NSLocalizedDescriptionKey:
                                    "No internet connection"
                            ])))
            }
            monitor.cancel()
        }
        monitor.start(queue: queue)
        
        // Wait a short period to check connectivity
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if !hasConnection {
                return
            }
            
            let storageRef = Storage.storage().reference().child(
                "\(localisationImage.rawValue)/\(uidUser)\(suffix).jpg")
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            print("@@@ here 1")
            
            storageRef.putData(imageData, metadata: metadata) {
                (metadata, error) in
                print("@@@ here 2")
                if let error = error {
                    print("@@@ error 2")
                    var userFriendlyErrorMessage = "An unknown error occurred."
                    
                    if let errCode = (error as NSError?)?.code {
                        switch errCode {
                        case -1009:
                            userFriendlyErrorMessage =
                            "No internet connection. Please check your network settings."
                        case -1001:
                            userFriendlyErrorMessage =
                            "The request timed out. Please try again later."
                        case -1004:
                            userFriendlyErrorMessage =
                            "Cannot connect to the server. Please try again later."
                        default:
                            userFriendlyErrorMessage =
                            "An error occurred: \(error.localizedDescription)"
                        }
                        print("@@@ error = \(errCode)")
                    }
                    
                    print(
                        "@@@ Error uploading image: \(userFriendlyErrorMessage)"
                    )
                    completion(.failure(error))
                    return
                }
                
                print("@@@ here 3")
                
                storageRef.downloadURL { (url, error) in
                    print("@@@ here 4")
                    if let error = error {
                        print("@@@ error 3")
                        print(
                            "@@@ Error getting download URL: \(error.localizedDescription)"
                        )
                        completion(.failure(error))
                        return
                    }
                    print("@@@ here 5")
                    if let url = url {
                        print("@@ Download URL: \(url.absoluteString)")
                        completion(.success(url.absoluteString))
                        print("@@@ here 6")
                    }
                }
            }
            print("@@@ uploadImageData out ")
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
