
import SwiftUI

struct AddFriendsScreen: View {
    @Binding var isPresented: Bool
    @StateObject var viewModel = AddFriendsViewModel()

    var body: some View {
        DraggableViewRight(isPresented: $isPresented) {
            SafeAreaContainer {
                VStack {
                    HeaderBackRightScreen(
                        onClickBack: {
                            withAnimation {
                                isPresented = false
                            }
                        },
                        titleScreen: "AJoute tes amis"
                    )

                    Divider()
                        .frame(height: 0.5)
                        .background(.white)
                        .padding(.bottom, 15)

                    
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack {
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
                                .padding(.top, 10)
                                
                                VStack(alignment: .leading) {
                                    ForEach(Array(viewModel.friendsList), id: \.self) { user in
                                        CellFriendPseudoNameAction(
                                            pseudo: user.pseudo,
                                            name: user.name,
                                            firstName: user.firstName,
                                            coordinator: Coordinator(),
                                            type: .add,
                                            isActionabled: {
                                                viewModel.addFriendsToList(user: user)
                                            }
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
        AddFriendsScreen(isPresented: .constant(true))
    }
}
