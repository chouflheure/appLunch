import SwiftUI

struct AddFriendsScreen: View {

    @StateObject var viewModel: AddFriendsViewModel
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var user: User

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self.user = coordinator.user ?? User()
        self._viewModel = StateObject(wrappedValue: AddFriendsViewModel(coordinator: coordinator))
    }

    var body: some View {
        DraggableViewRight(isPresented: $coordinator.showFriendListScreen) {
            SafeAreaContainer {
                VStack(spacing: 0) {
                    HeaderBackRightScreen(
                        onClickBack: {
                            withAnimation {
                                coordinator.showFriendListScreen = false
                            }
                        },
                        titleScreen: "AJoute tes amis",
                        isShowDivider: true
                    )

                    VStack(spacing: 0) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
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
                                .padding(.top, 20)

                                VStack(alignment: .leading) {
                                    ForEach(Array(viewModel.friendsList), id: \.self) { userFriend in
                                        CellFriendPseudoNameAction(
                                            user: userFriend,
                                            coordinator: coordinator,
                                            type: viewModel.statusFriend(user: user, userFriend: userFriend), //userFriends.contains(userFriend) ? .remove : .add,
                                            isActionabled: { type in
                                                if type == .add || type == .followBack {
                                                    viewModel.addFriendsToList(userFriend: userFriend)
                                                } else {
                                                    viewModel.cancelFriendsToList(userFriend: userFriend)
                                                }
                                            }
                                        ).onAppear {
                                            print("@@@ coordinator.user?.friends = \(user.friends)")
                                            print("@@@ userFriend.uid = \(userFriend.uid)")
                                        }
                                        .padding(.top, 15)
                                    }
                                }
                                .padding(.horizontal, 12)
                            }
                        }
                    }
                }
            }
        }
    }
}
