import SwiftUI

struct FriendCommumScreen: View {
    @StateObject var viewModel: AddFriendsViewModel
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var user: User
    @State var friendInCommun: Set<UserContact>
    @State var userFriend: Set<UserContact>

    init(coordinator: Coordinator, friendInCommun: Set<UserContact>, userFriend: Set<UserContact>) {
        self.coordinator = coordinator
        self._viewModel = StateObject(wrappedValue: AddFriendsViewModel(coordinator: coordinator))
        self.friendInCommun = friendInCommun
        self.user = coordinator.user ?? User()
        self.userFriend = userFriend
    }

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                CustomTabViewDoubleCommunFriends(
                    titles: ["En commun", "Tous"],
                    viewModel: viewModel,
                    coordinator: coordinator,
                    user: user,
                    dataFirstPage: $friendInCommun,
                    dataSecondPage: $userFriend
                )
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
                EmptyView()
            },
            hasADivider: true
        )

    }
}

struct CustomTabViewDoubleCommunFriends: View {
    @State private var selectedIndex = 0
    let titles: [String]
    @ObservedObject var viewModel: AddFriendsViewModel
    @ObservedObject var coordinator: Coordinator
    @ObservedObject var user: User
    @Binding var dataFirstPage: Set<UserContact>
    @Binding var dataSecondPage: Set<UserContact>

    var body: some View {
        VStack {
            // Votre header avec les titres
            HStack {
                ForEach(0..<titles.count, id: \.self) { index in
                    VStack {
                        Text(titles[index])
                            .tokenFont(.Body_Inter_Medium_12)
                            .foregroundColor(
                                selectedIndex == index ? .white : .gray)

                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(
                                selectedIndex == index ? .white : .clear
                            )
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
            .padding(.top, 20)

            if selectedIndex == 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        /*
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
                         */
                        VStack(alignment: .leading) {
                            ForEach(Array(dataFirstPage), id: \.self) {
                                userFriend in
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
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .transition(.move(edge: .leading))
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        
/*
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
*/
                        
                        VStack(alignment: .leading) {
                            ForEach(Array(dataSecondPage), id: \.self) {
                                userFriend in
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
                        }
                        .padding(.horizontal, 12)
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
    }
}
