import SwiftUI

struct AddFriendsScreen: View {

    @StateObject var viewModel = AddFriendsViewModel()
    @ObservedObject var coordinator: Coordinator

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
                                    ForEach(
                                        Array(viewModel.friendsList), id: \.self
                                    ) { user in
                                        CellFriendPseudoNameAction(
                                            user: user,
                                            coordinator: Coordinator(),
                                            type: .add,
                                            isActionabled: { viewModel.addFriendsToList(user: user) }
                                        )
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

#Preview {
    ZStack {
        NeonBackgroundImage()
        AddFriendsScreen(coordinator: Coordinator())
    }
}
