
import SwiftUI

struct ListFriendToAdd: View {
    @Binding var isPresented: Bool
    @ObservedObject var coordinator: Coordinator
    @StateObject private var viewModel: ListFriendToAddViewModel
    @Binding var friendsAdd: Set<UserContact>
    @Binding var teamToAdd: Set<Team>
    @Binding var allFriends: Set<UserContact>
    @Binding var allTeams: Set<Team>
    var showArrowDown: Bool
    
    init(
        isPresented: Binding<Bool>,
        coordinator: Coordinator,
        friendsAdd: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>,
        teamToAdd: Binding<Set<Team>>,
        allTeams: Binding<Set<Team>>,
        showArrowDown: Bool = true
    ) {
        self._isPresented = isPresented
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: ListFriendToAddViewModel(
                coordinator: coordinator,
                friendsAdd: friendsAdd,
                allFriends: allFriends,
                teamAdd: teamToAdd,
                allTeams: allTeams
            )
        )
        
        self._friendsAdd = friendsAdd
        self._allFriends = allFriends
        self._teamToAdd = teamToAdd
        self._allTeams = allTeams
        self.showArrowDown = showArrowDown
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBarView(
                    text: $viewModel.researchText,
                    placeholder: StringsToken.SearchBar.placeholderFriend,
                    onRemoveText: {
                        viewModel.removeText()
                    },
                    onTapResearch: {
                        viewModel.researche()
                    }
                )
                
                Spacer()
                if showArrowDown {
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(.iconArrow)
                            .resizable()
                            .foregroundStyle(.white)
                            .frame(width: 24, height: 24)
                            .rotationEffect(Angle(degrees: -90))
                    }
                }
            }
            .padding(.horizontal, 16)
            
            AddFriendsAndListView(
                arrayGuest: $friendsAdd,
                arrayFriends: $viewModel.displayedFriends,
                arrayTeamGuest: $teamToAdd,
                arrayTeam: $viewModel.displayedTeam,
                coordinator: coordinator,
                onRemove: { userRemoved in
                    viewModel.removeFriendsFromList(user: userRemoved)
                },
                onAdd: { userAdd in
                    viewModel.addFriendsToList(user: userAdd)
                },
                onRemoveTeam: { teamAdd in
                    viewModel.removeTeamFromList(team: teamAdd)
                },
                onAddTeam: { teamRemoved in
                    viewModel.addTeamToList(team: teamRemoved)
                }
            )
            .padding(.top, 30)
        }
    }
}

