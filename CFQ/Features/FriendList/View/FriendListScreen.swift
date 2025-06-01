
import SwiftUI

struct FriendListScreen: View {
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel: FriendListViewModel

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: FriendListViewModel(coordinator: coordinator))
    }

    var body: some View {
        DraggableViewLeft(isPresented: $coordinator.showFriendList) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                coordinator.showFriendList = false
                            }
                        },
                        titleScreen: StringsToken.Profile.Friends
                    )

                    VStack(alignment: .leading) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
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
                                .padding(.top, 15)
                                
                                ForEach(Array(viewModel.friendsList), id: \.self) { user in
                                    CellFriendPseudoNameAction(
                                        user: user,
                                        coordinator: coordinator,
                                        type: .remove,
                                        isActionabled: {_ in }
                                    )
                                    .padding(.top, 15)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
    }
}

struct FriendListScreen_Previews: PreviewProvider {
    static var previews: some View {
        FriendListScreen(coordinator: .init())
    }
}
