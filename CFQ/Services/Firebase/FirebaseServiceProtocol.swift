
internal protocol FirebaseServiceProtocol {
    func addData<T: Codable>(data: T, to collection: CollectionFirebaseType)
    func updateDataByID<T: Codable>(data: T, to collection: CollectionFirebaseType, with id: String)
    func getDataByID<T: Codable>(from collection: CollectionFirebaseType, whith id: String, completion: @escaping (Result<T, Error>) -> Void)
    func getAllData<T: Codable>(from collection: CollectionFirebaseType, completion: @escaping (Result<[T], Error>) -> Void)
    func getDataByID<T: Codable>(from collection: CollectionFirebaseType, whith id: String, completion: @escaping (Result<[T], Error>) -> Void)
}
