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
                    // Élément gauche : Bouton retour
                    Button(action: { }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .medium))
                            Text("Retour")
                                .font(.system(size: 17))
                        }
                        .foregroundColor(.white)
                    }
                },
                centerElement: {
                    // Élément centre : Titre personnalisé
                    VStack(spacing: 2) {
                        Text("Mon Titre")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("Sous-titre")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                },
                rightElement: {
                    // Élément droite : Menu avec notification
                    HStack(spacing: 12) {
                        Button(action: { print("Notifications") }) {
                            ZStack {
                                Image(systemName: "bell")
                                    .font(.system(size: 20))
                                    .foregroundColor(.white)
                                
                                if 1 > 0 {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Text("\(1)")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundColor(.white)
                                        )
                                        .offset(x: 10, y: -10)
                                }
                            }
                        }
                        
                        Menu {
                            Button("Option 1") { print("Option 1") }
                            Button("Option 2") { print("Option 2") }
                            Button("Paramètres") { print("Paramètres") }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
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
            .padding(.top, 20)

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
