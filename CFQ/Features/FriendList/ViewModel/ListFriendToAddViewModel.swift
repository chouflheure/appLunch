
import SwiftUI

class ListFriendToAddViewModel: ObservableObject {
    
    @Published var coordinator: Coordinator
    @Published var researchText = "" {
        didSet {
            updateDisplayedFriends()
            updateDisplayedTeam()
        }
    }

    @Binding var friendsAdd: Set<UserContact>
    @Binding var allFriends: Set<UserContact>
    @Binding var teamAdd: Set<Team>
    @Binding var allTeams: Set<Team>
    
    @Published var displayedFriends = Set<UserContact>()
    @Published var displayedTeam = Set<Team>()

    private var originalFriends = Set<UserContact>()
    private var originalTeams = Set<Team>()

    init(
        coordinator: Coordinator,
        friendsAdd: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>,
        teamAdd: Binding<Set<Team>>,
        allTeams: Binding<Set<Team>>
    ) {
        self.coordinator = coordinator
        self._friendsAdd = friendsAdd
        self._allFriends = allFriends
        self._teamAdd = teamAdd
        self._allTeams = allTeams

        let availableFriends = allFriends.wrappedValue.filter { !friendsAdd.wrappedValue.contains($0) }
        self.originalFriends = Set(availableFriends)
        self.displayedFriends = Set(availableFriends)
        
        let availableTeam = allTeams.wrappedValue.filter { !teamAdd.wrappedValue.contains($0) }
        self.originalTeams = Set(availableTeam)
        self.displayedTeam = Set(availableTeam)
    }
    
    private func updateDisplayedFriends() {
        if researchText.isEmpty {
            displayedFriends = originalFriends
        } else {
            let searchWords = researchText.split(separator: " ").map { $0.lowercased() }
            displayedFriends = originalFriends.filter { user in
                searchWords.allSatisfy { word in
                    user.pseudo.lowercased().hasPrefix(word.lowercased())
                }
            }
        }
    }
    
    private func updateDisplayedTeam() {
        if researchText.isEmpty {
            displayedTeam = originalTeams
        } else {
            let searchWords = researchText.split(separator: " ").map { $0.lowercased() }
            displayedTeam = originalTeams.filter { team in
                searchWords.allSatisfy { word in
                    team.title.lowercased().hasPrefix(word.lowercased())
                }
            }
        }
    }
    
    func removeFriendsFromList(user: UserContact) {
        friendsAdd.remove(user)
        originalFriends.insert(user)
        allFriends.insert(user)
        updateDisplayedFriends()
    }
    
    func addFriendsToList(user: UserContact) {
        friendsAdd.insert(user)
        originalFriends.remove(user)
        allFriends.remove(user)
        updateDisplayedFriends()
    }
    
    func removeText() {
        researchText.removeAll()
    }
    
    func researche() {
        updateDisplayedFriends()
        updateDisplayedTeam()
    }
    
    func removeTeamFromList(team: Team) {
        teamAdd.remove(team)
        originalTeams.insert(team)
        allTeams.insert(team)
        updateDisplayedTeam()
    }
    
    func addTeamToList(team: Team) {
        teamAdd.insert(team)
        originalTeams.remove(team)
        allTeams.remove(team)
        updateDisplayedTeam()
    }
}
