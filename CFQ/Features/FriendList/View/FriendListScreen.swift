import SwiftUI

struct FriendListScreen: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: FriendListViewModel
    @ObservedObject var user: User

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(
            wrappedValue: FriendListViewModel(coordinator: coordinator))
        self.user = coordinator.user ?? User()
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        SearchBarView(
                            text: $viewModel.researchText,
                            placeholder: StringsToken.SearchBar
                                .placeholderFriend,
                            onRemoveText: {
                                viewModel.removeText()
                            },
                            onTapResearch: {
                                viewModel.researche()
                            }
                        )
                        .padding(.top, 15)
                        ForEach(Array(viewModel.friendsList), id: \.self) { userFriend in
                            CellFriendPseudoNameAction(
                                user: user,
                                userFriend: userFriend,
                                coordinator: coordinator,
                                isActionabled: { type in
                                    viewModel.actionOnClickButtonAddFriend(
                                        type: type, userFriend: userFriend)
                                }
                            )
                            .padding(.top, 15)
                        }
                        .padding(.horizontal, 12)
                    }
                }
            }
            .customNavigationFlexible(
                leftElement: {
                    NavigationBackIcon()
                },
                centerElement: {
                    NavigationTitle(title: StringsToken.Profile.Friends)
                },
                rightElement: {
                    EmptyView()
                },
                hasADivider: true
            )
        }
    }
}

struct FriendListScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendListScreen(coordinator: .init())
    }
}
