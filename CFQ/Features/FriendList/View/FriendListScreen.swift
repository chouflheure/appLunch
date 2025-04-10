
import SwiftUI

struct FriendListScreen: View {
    @ObservedObject var coordinator: Coordinator
    @Binding var show: Bool
    @State private var dragOffset: CGFloat = 0
    @StateObject var viewModel = FriendListViewModel()

    var body: some View {
        DraggableView(isPresented: $show) {
            SafeAreaContainer {
                VStack {
                    HeaderBackLeftScreen(
                        onClickBack: {
                            withAnimation {
                                show = false
                            }
                        },
                        titleScreen: StringsToken.Profile.Friends
                    )

                    Divider()
                        .background(.white)

                    VStack(alignment: .leading) {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading) {
                                SearchBarView(
                                    text: $viewModel.researchText,
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
                                        pseudo: user.pseudo,
                                        name: user.name,
                                        firstName: user.firstName,
                                        coordinator: coordinator,
                                        type: .remove,
                                        isActionabled: {}
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
        FriendListScreen(coordinator: .init(), show: .constant(false))
    }
}
