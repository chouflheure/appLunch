
// chunked pemet de découper les tableaux en plusieurs parties

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

/*
 Exemple :
 
 [1,2,3,4,5,6,7,8,9,10,11].chunked(into: 4)
 // Résultat: [[1,2,3,4], [5,6,7,8], [9,10,11]]
 
 */
