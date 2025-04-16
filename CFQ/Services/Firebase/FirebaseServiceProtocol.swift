
internal protocol FirebaseServiceProtocol {
    func addData<T: Codable>(data: T, to collection: CollectionFirebaseType, completion: @escaping (Result<Void, Error>) -> (Void))
    func updateDataByID(data: [String: Any], to collection: CollectionFirebaseType, at id: String)
    func getAllData<T: Codable>(from collection: CollectionFirebaseType, completion: @escaping (Result<[T], Error>) -> Void)
    func deleteDataByID(from collection: CollectionFirebaseType, at id: String, completion: @escaping (Result<Void, Error>) -> Void)
    func getDataByID<T: Codable>(from collection: CollectionFirebaseType, with id: String, completion: @escaping (Result<T, Error>) -> Void)
    
}
