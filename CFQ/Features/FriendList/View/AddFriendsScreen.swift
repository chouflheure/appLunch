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
        
            SafeAreaContainer {
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        CustomTabViewDouble(titles: ["Recherche", "Les demandes"], viewModel: viewModel, coordinator: coordinator, user: user)
                    }
                }
            }
            .customNavigationFlexible(
                leftElement: {
                    NavigationBackIcon()
                },
                centerElement: {
                    NavigationTitle(title: "AJoute tes amis")
                },
                rightElement: {
                    Text("")
                },
                hasADivider: true
            )
        /*
            .customNavigationBackButton {
                HeaderBackLeftScreen(
                    onClickBack: {
                        withAnimation {
                            coordinator.showFriendListScreen = false
                        }
                    },
                    titleScreen: "AJoute tes amis",
                    isShowDivider: true
                )
            }
         */
    }
}

struct CustomTabViewDouble: View {
    @State private var selectedIndex = 0
    let titles: [String]
    @ObservedObject var viewModel: AddFriendsViewModel
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var user: User

    var body: some View {
        VStack {
            // Votre header avec les titres
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .tokenFont(.Body_Inter_Medium_12)
                            .foregroundColor(selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(selectedIndex == index ? .white : .clear)
                            .padding(.horizontal, 30)
                    }
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        withAnimation {
                            selectedIndex = index
                        }
                    }
                }
            }

            if selectedIndex == 0 {
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
                                NavigationLink(
                                    destination: FriendProfileView(
                                        coordinator: coordinator,
                                        user: user,
                                        friend: userFriend
                                    )
                                ) {
                                    CellFriendPseudoNameAction(
                                        user: user,
                                        userFriend: userFriend,
                                        coordinator: coordinator,
                                        isActionabled: { type in
                                            viewModel.actionOnClickButtonAddFriend(type: type, userFriend: userFriend)
                                        }
                                    )
                                    .padding(.top, 15)
                                }
                                
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .transition(.move(edge: .leading))
            } else {
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
                            ForEach(Array(viewModel.requestsFriends), id: \.self) { userFriend in
                                CellFriendPseudoNameAction(
                                    user: user,
                                    userFriend: userFriend,
                                    coordinator: coordinator,
                                    isActionabled: { type in
                                        viewModel.actionOnClickButtonAddFriend(type: type, userFriend: userFriend)
                                    }
                                )
                                .padding(.top, 15)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}
