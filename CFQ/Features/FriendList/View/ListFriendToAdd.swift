
import SwiftUI

struct ListFriendToAdd: View {
    @Binding var isPresented: Bool
    @ObservedObject var coordinator: Coordinator
    @StateObject private var viewModel: ListFriendToAddViewModel
    @Binding var friendsOnTeam: Set<UserContact>
    @Binding var allFriends: Set<UserContact>
    var showArrowDown: Bool
    
    init(
        isPresented: Binding<Bool>,
        coordinator: Coordinator,
        friendsOnTeam: Binding<Set<UserContact>>,
        allFriends: Binding<Set<UserContact>>,
        showArrowDown: Bool = true
    ) {
        self._isPresented = isPresented
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: ListFriendToAddViewModel(
                coordinator: coordinator,
                friendsOnTeam: friendsOnTeam,
                allFriends: allFriends
            )
        )
        
        self._friendsOnTeam = friendsOnTeam
        self._allFriends = allFriends
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
                arrayGuest: $friendsOnTeam,
                arrayFriends: $viewModel.displayedFriends,
                arrayTeamGuest: .constant([]),
                arrayTeam: .constant([]),
                coordinator: coordinator,
                onRemove: { userRemoved in
                    viewModel.removeFriendsFromList(user: userRemoved)
                },
                onAdd: { userAdd in
                    viewModel.addFriendsToList(user: userAdd)
                },
                onRemoveTeam: {_ in},
                onAddTeam: {_ in}
            )
            .padding(.top, 30)
        }
    }
}

