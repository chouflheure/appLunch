import SwiftUI

struct TeamDetailView: View {
    @StateObject var viewModel: TeamDetailViewModel

    @State var isPresentedSeetings = false
    @State var navigateToTeamEdit = false
    @State var showAlertRemoveTeam = false

    @ObservedObject var coordinator: Coordinator
    @ObservedObject var team: Team
    var isEditable: Bool

    @EnvironmentObject var user: User
    @Environment(\.dismiss) var dismiss
    @State private var toast: Toast? = nil

    init(coordinator: Coordinator, team: Team, isEditable: Bool = true) {
        self.coordinator = coordinator
        self.team = team
        self.isEditable = isEditable
        self._viewModel = StateObject(
            wrappedValue: TeamDetailViewModel(coordinator: coordinator)
        )
    }

    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    ModernCachedAsyncImage(
                        url: team.pictureUrlString,
                        placeholder: Image(systemName: "photo.fill")
                    )
                    .clipShape(Circle())
                    .frame(width: 90, height: 90)
                    .padding(.bottom, 16)

                    if isEditable {
                        NavigationLink(destination: {
                            TurnCardView(
                                turn: Turn(
                                    uid: "",
                                    titleEvent: "",
                                    dateStartEvent: nil,
                                    pictureURLString: "",
                                    admin: "",
                                    description: "",
                                    invited: team.friends,
                                    participants: [],
                                    denied: [],
                                    mayBeParticipate: [],
                                    mood: [],
                                    messagerieUUID: "",
                                    placeTitle: "",
                                    placeAdresse: "",
                                    placeLatitude: 0,
                                    placeLongitude: 0,
                                    timestamp: Date()
                                ),
                                coordinator: coordinator
                            )
                        }) {
                            HStack {
                                Image(.iconPlus)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.white)

                                Text("Créer un TURN pour la team")
                                    .tokenFont(.Body_Inter_Semibold_16)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(.white, lineWidth: 1)
                        }
                        .padding(.bottom, 16)
                    }
                    
                    Divider()
                        .overlay(.white)

                    ScrollView(.horizontal, showsIndicators: false) {
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(
                                    team.friendsContact ?? [],
                                    id: \.uid
                                ) { user in
                                    CellFriendAdmin(
                                        userPreview: user,
                                        isEditingAdmin: .constant(false),
                                        isAdmin: Binding(
                                            get: {
                                                guard
                                                    let admins = team
                                                        .adminsContact
                                                else { return false }
                                                return admins.contains(where: {
                                                    $0.uid == user.uid
                                                })
                                            },
                                            set: { newValue in
                                                guard
                                                    coordinator.teamDetail
                                                        != nil
                                                else { return }

                                                if newValue {
                                                    let isAlreadyAdmin =
                                                        team.adminsContact?
                                                        .contains(where: {
                                                            $0.uid == user.uid
                                                        }) ?? false
                                                    if !isAlreadyAdmin {
                                                        team.adminsContact?
                                                            .append(user)
                                                    }
                                                } else {
                                                    team.adminsContact?
                                                        .removeAll {
                                                            $0.uid == user.uid
                                                        }
                                                }
                                            }
                                        )
                                    )
                                    .padding(.trailing, 12)
                                }
                                .frame(height: 110)
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .overlay(.white)


                    Divider()
                        .overlay(.white)

                    LazyVStack(spacing: 20) {
                        ForEach(team.turns?.sorted(by: { $0.timestamp > $1.timestamp}) ?? [], id: \.uid) { turn in
                            NavigationLink(
                                destination: TurnCardDetailsFeedView(
                                    coordinator: coordinator,
                                    turn: turn,
                                    user: user
                                )
                            ) {
                                TurnCardFeedView(
                                    turn: turn, coordinator: coordinator
                                )
                                .padding(.horizontal, 12)
                            }
                        }
                    }.padding(.top, 24)
                }
            }
        }
        .padding(.vertical, 30)
        .sheet(isPresented: $isPresentedSeetings) {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                VStack(alignment: .trailing, spacing: 30) {
                    if team.admins.contains(user.uid) {
                        Button(action: {
                            isPresentedSeetings = false
                            navigateToTeamEdit = true
                        }) {
                            HStack {
                                Image(.iconEdit)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20)

                                Text("Modifier la team")
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }

                        Button(action: {
                            isPresentedSeetings = false
                            showAlertRemoveTeam = true
                        }) {
                            HStack {
                                Image(.iconTrash)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 20)

                                Text("Supprimer la team")
                                    .foregroundColor(.white)

                                Spacer()
                            }
                        }
                    }

                    HStack {
                        Image(.iconDoor)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.white)
                        Button(
                            action: {
                                Logger.log("Quitter la team", level: .action)
                                isPresentedSeetings = false
                                viewModel.leaveTeam(
                                    team: team,
                                    userUUID: user.uid
                                )
                                dismiss()
                            },
                            label: {
                                Text("Quitter la team")
                                    .tokenFont(.Body_Inter_Medium_16)
                            }
                        )
                        Spacer()
                    }
                }
                .padding(.leading, 12)
            }
            .presentationDragIndicator(.visible)
            .presentationDetents([.height(120)])
        }
        .navigationDestination(isPresented: $navigateToTeamEdit) {
            TeamEditViewScreen(coordinator: coordinator, team: team)
        }
        .alert(isPresented: $showAlertRemoveTeam) {
            CustomDialog(
                title: "Tu surpprime cette Team, t'es sur ?",
                content: "",
                image: .init(
                    content: "trash",
                    tint: .black,
                    foreground: .white
                ),
                button1: .init(
                    content: "Garder",
                    tint: .purpleText,
                    foreground: .white,
                    action: { _ in
                        showAlertRemoveTeam = false
                    }
                ),
                button2: .init(
                    content: "Yes, No team",
                    tint: .red,
                    foreground: .white,
                    action: { _ in
                        showAlertRemoveTeam = false
                        viewModel.removeTeam(team: team) { success, message in
                            if success {
                                dismiss()
                            } else {
                                toast = Toast(
                                    style: .error,
                                    message: message
                                )
                            }
                        }
                    }
                )
            )
            .transition(.blurReplace)
        } background: {
            Rectangle()
                .fill(.primary.opacity(0.35))
                .onTapGesture {
                    showAlertRemoveTeam = false
                }
        }
        .toastView(toast: $toast)
        .customNavigationFlexible(
            leftElement: {
                NavigationBackIcon()
            },
            centerElement: {
                NavigationTitle(title: team.title)
            },
            rightElement: {
                Button(action: {
                    isPresentedSeetings = true
                }) {
                    if isEditable {
                        Image(.iconDots)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 24)
                    }
                }
            },
            hasADivider: false
        )
    }
}
