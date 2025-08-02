
import SwiftUI

class FriendListStatusTurnInvitationViewModel: ObservableObject {
    @Published var invited: [UserContact] = []
    @Published var participants: [UserContact] = []
    @Published var denied: [UserContact] = []
    @Published var mayBe: [UserContact] = []
    @Published var turn: Turn
    
    private var firebaseService = FirebaseService()

    init(turn: Turn) {
        self.turn = turn
        fetchContacts(ids: turn.invited)
    }
    
    private func fetchContacts(ids: [String]) {
        firebaseService.getDataByIDs(
            from: .users,
            with: ids
        ){ (result: Result<[UserContact], Error>) in
            switch result {
            case .success(let userContact):
                DispatchQueue.main.async {
                    self.invited = userContact
                    self.updateFilteredArrays()
                }
            case .failure(let error):
                print("👎 Erreur : \(error.localizedDescription)")
                
            }
        }
    }

    private func updateFilteredArrays() {
        participants = invited.filter { user in
            turn.participants.contains(user.uid)
        }
        denied = invited.filter { user in
            turn.denied.contains(user.uid)
        }
        mayBe = invited.filter { user in
            turn.mayBeParticipate.contains(user.uid)
        }
    }
}


struct FriendListStatusTurnInvitation: View {
    @State var selectedIndex = 0
    var pageViewType: PageViewType = .attendingGuestsView
    @StateObject var viewModel: FriendListStatusTurnInvitationViewModel
    @ObservedObject var coordinator: Coordinator

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    init(turn: Turn, coordinator: Coordinator) {
        _viewModel = StateObject(wrappedValue: FriendListStatusTurnInvitationViewModel(turn: turn))
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    ForEach(0..<pageViewType.titles.count, id: \.self) { index in
                        VStack {
                            Text(pageViewType.title(at: index))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(selectedIndex == index ? .white : .gray)

                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(selectedIndex == index ? .white : .clear)
                                .padding(.horizontal, 10)
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

                ScrollView(.vertical, showsIndicators: false) {
                    if selectedIndex == 0 {
                        LazyVStack(spacing: 20) {
                            if viewModel.invited.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            } else {
                                CollectionViewParticipant(participants: $viewModel.invited, coordinator: coordinator)
                            }
                        }
                        .padding(.top, 24)
                    } else if selectedIndex == 1 {
                        LazyVStack(spacing: 20) {
                            if viewModel.invited.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            }
                            else {
                                CollectionViewParticipant(participants: $viewModel.participants, coordinator: coordinator)
                            }
                        }
                        .padding(.top, 24)
                    } else if selectedIndex == 2 {
                        LazyVStack(spacing: 20) {
                            if viewModel.invited.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            }
                            else {
                                CollectionViewParticipant(participants: $viewModel.mayBe, coordinator: coordinator)
                            }
                        }
                        .padding(.top, 24)
                    } else {
                        LazyVStack(spacing: 20) {
                            if viewModel.invited.isEmpty {
                                Text("Personne ici")
                                    .tokenFont(.Label_Gigalypse_12)
                                    .padding(.top, 200)
                            }
                            else {
                                CollectionViewParticipant(participants: $viewModel.denied, coordinator: coordinator)
                            }
                        }
                        .padding(.top, 24)
                    }
                    
                }
            }
        }
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: StringsToken.AttentingGuest.titleAttendingGuest)
            },
            rightElement: {
                EmptyView()
            },
            hasADivider: true
        )
    }
}

struct ItemView: View {
    let participant: UserContact

    var body: some View {
        VStack(alignment: .center) {
            CirclePicture(urlStringImage: participant.profilePictureUrl)
                .frame(width: 60, height: 60)
            Text(participant.pseudo)
                .tokenFont(.Body_Inter_Medium_14)
        }
    }
}


struct CollectionViewParticipant: View {
    @Binding var participants: [UserContact]
    @ObservedObject var coordinator: Coordinator

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {

        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(participants, id: \.self) { participant in
                    NavigationLink(destination: {
                        FriendProfileView(
                            coordinator: coordinator,
                            user: coordinator.user ?? User(),
                            friend: participant
                        )
                    }) {
                        ItemView(participant: participant)
                    }
                }
            }
            .padding()
        }.scrollIndicators(.hidden)
    }
}
