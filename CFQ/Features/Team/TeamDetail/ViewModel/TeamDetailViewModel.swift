import Foundation

class TeamDetailViewModel: ObservableObject {
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
 
    func isAdmin(userUUID: String, admins: [UserContact]?) -> Bool {
        var adminsUUID = [String]()
        guard let admins = admins else { return false }

        admins.forEach({
            adminsUUID.append($0.uid)
        })

        return adminsUUID.contains(userUUID)
    }
    
    func titleError(error: Error) -> String {
        
        return "Error"
    }
}
