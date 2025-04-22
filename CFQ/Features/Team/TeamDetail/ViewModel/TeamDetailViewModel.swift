import Foundation

class TeamDetailViewModel: ObservableObject {
    @Published var showEditTeam: Bool = false
    @Published var showSheetSettingTeam: Bool = false
    @Published var isAdminEditing: Bool = false
    @Published var showSheetAddFriend: Bool = false
    
}
