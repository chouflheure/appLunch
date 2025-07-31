
import SwiftUI

class ListFriendToAddViewModel: ObservableObject {
    
    @Published var coordinator: Coordinator
    @Published var researchText = "" {
        didSet {
            updateDisplayedFriends()
        }
    }

    @Binding var friendsOnTeam: Set<UserContact>
    @Binding var allFriends: Set<UserContact>
    @Published var displayedFriends = Set<UserContact>()
    private var originalFriends = Set<UserContact>()

    init(
        coordinator: Coordinator,
        friendsOnTeam: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>
    ) {
        self.coordinator = coordinator
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
        
        let availableFriends = allFriends.wrappedValue.filter { !friendsOnTeam.wrappedValue.contains($0) }
        self.originalFriends = Set(availableFriends)
        self.displayedFriends = Set(availableFriends)
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
    
    func removeFriendsFromList(user: UserContact) {
        friendsOnTeam.remove(user)
        originalFriends.insert(user)
        allFriends.insert(user)
        updateDisplayedFriends()
    }
    
    func addFriendsToList(user: UserContact) {
        friendsOnTeam.insert(user)
        originalFriends.remove(user)
        allFriends.remove(user)
        updateDisplayedFriends()
    }
    
    func removeText() {
        researchText.removeAll()
    }
    
    func researche() {
        updateDisplayedFriends()
    }
}
