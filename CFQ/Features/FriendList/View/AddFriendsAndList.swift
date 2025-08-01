class AddFriendsAndListViewModel: ObservableObject {
    @Published var guestCount: Set<String> = []

    func guestCount(arrayGuest: Set<UserContact>, arrayTeamGuest: Set<Team>) {
        guestCount = []
        arrayTeamGuest.forEach { team in
            team.friends.forEach { user in
                guestCount.insert(user)
            }
        }
        
        arrayGuest.forEach { user in
            guestCount.insert(user.uid)
        }
    }
}

import SwiftUI

struct AddFriendsAndListView: View {
    @Binding var arrayGuest: Set<UserContact>
    @Binding var arrayFriends: Set<UserContact>
    @Binding var arrayTeamGuest: Set<Team>
    @Binding var arrayTeam: Set<Team>
    @ObservedObject var coordinator: Coordinator
    @StateObject var viewModel = AddFriendsAndListViewModel()

    var onRemove: ((UserContact) -> Void)
    var onAdd: ((UserContact) -> Void)
    var onRemoveTeam: ((Team) -> Void)
    var onAddTeam: ((Team) -> Void)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Invité\(viewModel.guestCount.count > 1 ? "s" : "") :")
                    .foregroundColor(.white)

                Text(viewModel.guestCount.count.description)
                    .foregroundColor(.white)
            }.padding(.horizontal, 16)

            VStack(alignment: .leading) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Array(arrayTeamGuest), id: \.self) { team in
                            NavigationLink(
                                destination: TeamDetailView(
                                    coordinator: coordinator,
                                    team: team,
                                    isEditing: false
                                )
                            ) {
                                CellTeamCanRemove(team: team) {
                                    onRemoveTeam(team)
                                    viewModel.guestCount(arrayGuest: arrayGuest, arrayTeamGuest: arrayTeamGuest)
                                }
                            }
                        }

                        ForEach(Array(arrayGuest), id: \.self) { friend in
                            NavigationLink(
                                destination: FriendProfileView(
                                    coordinator: coordinator,
                                    user: coordinator.user ?? User(),
                                    friend: friend
                                )
                            ) {
                                CellFriendCanRemove(userPreview: friend) {
                                    onRemove(friend)
                                    viewModel.guestCount(arrayGuest: arrayGuest, arrayTeamGuest: arrayTeamGuest)
                                }
                            }
                        }
                    }.frame(height: viewModel.guestCount.isEmpty ? 0 : 100)
                }
            }

            Divider()
                .background(.white)

            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(Array(arrayTeam), id: \.self) { team in
                            NavigationLink(
                                destination:
                                    TeamDetailView(
                                        coordinator: coordinator,
                                        team: team,
                                        isEditing: false
                                    )
                            ) {
                                CellTeamAdd(team: team) {
                                    onAddTeam(team)
                                    viewModel.guestCount(arrayGuest: arrayGuest, arrayTeamGuest: arrayTeamGuest)
                                }
                                .padding(.top, 15)
                            }
                        }
                        
                        ForEach(Array(arrayFriends), id: \.self) { friend in
                            NavigationLink(
                                destination: FriendProfileView(
                                    coordinator: coordinator,
                                    user: coordinator.user ?? User(),
                                    friend: friend
                                )
                            ) {
                                CellFriendsAdd(userPreview: friend) {
                                    onAdd(friend)
                                    viewModel.guestCount(arrayGuest: arrayGuest, arrayTeamGuest: arrayTeamGuest)
                                }
                                .padding(.top, 15)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.guestCount(arrayGuest: arrayGuest, arrayTeamGuest: arrayTeamGuest)
        }
    }
}
