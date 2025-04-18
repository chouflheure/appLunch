
class DataApp: Codable, Hashable {
    let version: String
    let isNeedToUpdateApp: Bool
    
    init(
        version: String = "",
        isNeedToUpdateApp: Bool = false
    ) {
        self.version = version
        self.isNeedToUpdateApp = isNeedToUpdateApp
    }
    
    // Conformité à Equatable
    static func == (lhs: DataApp, rhs: DataApp) -> Bool {
        return lhs.version == rhs.version &&
               lhs.isNeedToUpdateApp == rhs.isNeedToUpdateApp
    }

    // Conformité à Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(version)
        hasher.combine(isNeedToUpdateApp)
    }
}
